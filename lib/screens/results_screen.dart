import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:scannerv3/helpers/database_helper.dart';
import 'package:scannerv3/models/exam.dart';
import 'package:scannerv3/models/offline/response_offline.dart';
import 'package:scannerv3/screens/edit_response_screen.dart';
import 'package:scannerv3/utils/token_manager.dart';
import 'package:scannerv3/values/api_endpoints.dart';
import 'package:scannerv3/widgets/results_options_widget.dart';
import 'package:sqflite/sqflite.dart';

class ResultsScreen extends StatefulWidget {
  final List<String> answer;
  final List<String> answerKey;
  final Exam exam;
  final TextEditingController _controller = TextEditingController();
  String studentId;
  int score = 0;
  int detected = 0;

  ResultsScreen(
      {super.key,
      required this.answer,
      required this.studentId,
      required this.exam,
      required this.answerKey});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _isSaving = false;
  String _errorMessage = "";
  final Dio _dio = Dio();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget._controller.value = TextEditingValue(text: widget.studentId);
    setScore();
    setDetected();
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

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> saveResponse() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final token = await TokenManager().getAuthToken();
      final data = {
        "exam_id": widget.exam.id,
        "student_number": widget.studentId,
        "answer": widget.answer.join(),
        "score": widget.score,
        "detected": widget.detected,
        "image_path": ""
      };

      if (token != null) {
        print("hey");
        print(widget.studentId);
        final res = await _dio.post(ApiEndpoints.responses,
            data: data, options: Options(headers: {'Authorization': token}));

        if (res.statusCode == 200) {
          final response = res.data;

          print(response);

          // save to db
          ResponseOffline responseOffline = ResponseOffline(
              response["id"],
              response["exam_id"],
              response["user_id"],
              response["student_number"],
              response["image_path"],
              response["detected"],
              response["score"],
              response["answer"],
              DateTime.parse(response["created_at"]));

          // insert to db for offline access
          final db = await DatabaseHelper().database;
          db.insert('responses', responseOffline.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);

          _showDialog("Response Saved", "Response is saved");
        } else {
          _errorMessage = 'Error saving response';
        }
      }
    } on DioException catch (error) {
      setState(() {
        _errorMessage =
            error.response?.data['errors'][0] ?? 'Error fetching data';
      });

      _showDialog("Save Error", _errorMessage);
    }

    setState(() {
      _isSaving = false;
    });
  }

  void _editStudId(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Edit Student ID"),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                            updateAnswer: (String a, int b) => {
                                  setState(() {
                                    widget.answer[b] = a;
                                  }),
                                  setDetected(),
                                  setScore()
                                })));
              }

              if (value == "Save Response") {
                saveResponse();
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Edit Response', 'Save Response', 'Discard and Rescan'}
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
      body: Column(
        children: [
          Container(
            color: const Color.fromRGBO(101, 188, 80, 1),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text("Exam Name:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.exam.name)
                ]),
                Row(children: [
                  const Text("Responses:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(12.toString())
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
                        child: Row(
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
