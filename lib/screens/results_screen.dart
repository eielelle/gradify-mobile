import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:scannerv3/camera_screen.dart';
import 'package:scannerv3/helpers/database_helper.dart';
import 'package:scannerv3/helpers/dialog_helper.dart';
import 'package:scannerv3/helpers/loader_helper.dart';
import 'package:scannerv3/models/exam.dart';
import 'package:scannerv3/models/offline/response_offline.dart';
import 'package:scannerv3/screens/edit_response_screen.dart';
import 'package:scannerv3/screens/home_screen.dart';
import 'package:scannerv3/utils/token_manager.dart';
import 'package:scannerv3/values/api_endpoints.dart';
import 'package:sqflite/sqflite.dart';

class ResultsScreen extends StatefulWidget {
  List<String> answer;
  final List<String> answerKey;
  final Exam exam;
  final TextEditingController _controller = TextEditingController();
  String studentId;
  int score = 0;
  int detected = 0;
  final ResponseOffline? existingResponse;
  String studentName = "Unknown Student";

  ResultsScreen(
      {super.key,
      required this.answer,
      required this.studentId,
      required this.exam,
      required this.answerKey,
      this.existingResponse});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _isSaving = false;
  final Dio _dio = Dio();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget._controller.value = TextEditingValue(text: widget.studentId);
    setScore();
    setDetected();
    setStud();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget._controller.dispose();
    super.dispose();
  }

  void setDetected() {
    int errorCount = widget.answer.where((char) => char == '?').length;

    setState(() {
      widget.detected = 50 - errorCount;
    });
  }

  void setScore() {
    int score = 0;

    for (int i = 0; i < min(widget.answer.length, 50); i++) {
      if (widget.answer[i].contains(widget.answerKey[i])) {
        score++;
      }
    }
    setState(() {
      widget.score = score;
    });
  }

  void setStud() async {
    print("AAAAAAAAAAAAAAAAAAA");
    print("GETTING STUDENT NAME");
    final Map<String, dynamic> data = {
      "student_number": widget.studentId,
    };

    try {
      final token = await TokenManager().getAuthToken();

      if (token != null) {
        final res = await _dio.get(ApiEndpoints.studentName,
            data: data, options: Options(headers: {'Authorization': token}));

        if (res.statusCode == 200) {
          setState(() {
            widget.studentName = res.data?["student"];
          });
        } else {
          setState(() {
            widget.studentName = "Bad request";
          });
        }
      }
    } on DioException catch (error) {
      String msg = "Something went wrong";

      setState(() {
        widget.studentName = msg;
      });
    }
  }

  Future<void> saveResponseWithFallback() async {
    final Map<String, dynamic> data = {
      "exam_id": widget.exam.id,
      "student_number": widget.studentId,
      "answer": widget.answer.join(),
      "score": widget.score,
      "detected": widget.detected,
      "image_path": widget.answer.join(),
      "created_at": DateTime.now().toString()
    };

    setState(() {
      _isSaving = true;
    });

    bool savedWeb = await saveResponse(data);

    if (!savedWeb) {
      await saveLocal(data);
    }

    setState(() {
      _isSaving = false;
    });
  }

  Future<bool> saveLocal(Map<String, dynamic> data) async {
    try {
      // save to db
      ResponseOffline responseOffline = ResponseOffline(
          name: widget.existingResponse?.name ?? "Unknown Student",
          email: widget.existingResponse?.email ?? "No email provided",
          examId: data["exam_id"],
          studentNumber: data["student_number"],
          imagePath: data["image_path"],
          detected: data["detected"],
          score: data["score"],
          answer: data["answer"],
          createdAt: DateTime.parse(data["created_at"]));

      // insert to db for offline access
      final db = await DatabaseHelper().database;
      final ok = await db.insert('responses', responseOffline.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      return ok != 0;
    } catch (error) {
      if (mounted) {
        DialogHelper.showCustomDialog(
            title: "Database Error",
            subtitle: "Cannot save response offline",
            context: context);
      }
    }

    return false;
  }

  Future<bool> saveResponse(Map<String, dynamic> data) async {
    try {
      final token = await TokenManager().getAuthToken();

      if (token != null) {
        final res = await _dio.post(ApiEndpoints.responses,
            data: data, options: Options(headers: {'Authorization': token}));

        if (res.statusCode == 200) {
          // save to db
          ResponseOffline responseOffline = ResponseOffline(
              name: widget.existingResponse?.name ?? "Unknown Student",
              email: widget.existingResponse?.email ?? "No email provided",
              examId: data["exam_id"],
              studentNumber: data["student_number"],
              imagePath: data["image_path"],
              detected: data["detected"],
              score: data["score"],
              answer: data["answer"],
              createdAt: DateTime.parse(data["created_at"]));

          // insert to db for offline access
          final db = await DatabaseHelper().database;
          final ok = await db.insert('responses', responseOffline.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);

          if (mounted) {
            DialogHelper.showCustomDialog(
                title: "Response is saved",
                subtitle: "Response is saved and synced to web.",
                context: context);
          }

          return true;
        } else {
          if (mounted) {
            DialogHelper.showCustomDialog(
                title: "Response not saved",
                subtitle: "Something went wrong.",
                context: context);
          }
        }
      }
    } on DioException catch (error) {
      String msg = "Something went wrong";

      if (error.response != null) {
        msg = error.response?.data["errors"][0];

        if (mounted) {
          DialogHelper.showCustomDialog(
              title: "Saved Response Offline",
              subtitle: "Failed to sync response online. $msg",
              context: context);
        }
      } else {
        if (mounted) {
          DialogHelper.showCustomDialog(
              title: "Saved Response Offline",
              subtitle: "Response is only saved locally.",
              context: context);
        }
      }
    }

    return false;
  }

  void _editStudId(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Edit Student ID"),
            content: TextField(
              controller: widget._controller,
              keyboardType: TextInputType.number,
              maxLength: 5,
              decoration: InputDecoration(counterText: ""),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: widget._controller.text.isEmpty
                    ? null
                    : () {
                        // Handle the number input
                        setState(() {
                          widget.studentId = widget._controller.text;
                          Navigator.of(context).pop();
                        });

                        setStud();
                      },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(41, 46, 50, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(101, 188, 80, 1),
        title: const Text("Answer Key"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "Edit Response") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditResponseScreen(
                            answer: widget.answer,
                            answerKey: widget.answerKey,
                            updateAnswer: (List<String> a) => {
                                  setState(() {
                                    widget.answer = a;
                                  }),
                                  setScore()
                                })));
              }

              if (value == "Save Response") {
                saveResponseWithFallback();
              }

              if (value == "Rescan") {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CameraScreen(exam: widget.exam)),
                    (route) => false);
              }

              if (value == 'Close') {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false);
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Edit Response', 'Save Response', 'Rescan', 'Close'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: const Icon(Icons.more_vert), // Icon for the menu
          )
        ],
      ),
      body: _isSaving
          ? Center(child: LoaderHelper.showLoading())
          : Column(
              children: [
                Container(
                  color: const Color.fromRGBO(101, 188, 80, 1),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text("Exam Name: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.exam.name)
                      ]),
                      const SizedBox(height: 12),
                      Text(widget.exam.quarterName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Divider(),
                      Text(widget.exam.subjectName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          const Text("Student: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(widget.studentName),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Student ID: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(widget.studentId),
                          IconButton(
                              onPressed: () {
                                _editStudId(context);
                              },
                              icon: Icon(Iconsax.edit))
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Detected Bubbles: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("${widget.detected}/50"),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Score: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("${widget.score}/50"),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: widget.answer.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("${index + 1}: ",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                              color: Colors.white)),
                                      _buildBubble("A", index),
                                      _buildBubble("B", index),
                                      _buildBubble("C", index),
                                      _buildBubble("D", index),
                                      _buildBubble("E", index),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "Correct Answer: ${widget.answerKey[index]}",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ));
                        }))
              ],
            ),
    );
  }

  Widget _buildBubble(String label, int index) {
    bool isKey = widget.answer[index].contains(label);
    bool isCorrect = widget.answer[index].contains(widget.answerKey[index]);

    return Container(
      margin: EdgeInsets.only(right: 8),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isKey
            ? isCorrect
                ? Colors.green
                : Colors.red
            : Colors.grey,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
