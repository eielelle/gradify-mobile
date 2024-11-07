import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scannerv3/helpers/database_helper.dart';
import 'package:scannerv3/helpers/toast_helper.dart';
import 'package:scannerv3/models/exam.dart';
import 'package:scannerv3/models/offline/response_offline.dart';
import 'package:scannerv3/screens/results_screen.dart';
import 'package:scannerv3/utils/token_manager.dart';
import 'package:scannerv3/values/api_endpoints.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class ViewResponsesScreen extends StatefulWidget {
  final int examId;
  final Exam exam;

  const ViewResponsesScreen(
      {super.key, required this.examId, required this.exam});

  @override
  State<ViewResponsesScreen> createState() => _ViewResponsesScreenState();
}

class _ViewResponsesScreenState extends State<ViewResponsesScreen> {
  Future<void> syncResponses() async {
    try {
      final list = [];
      final token = await TokenManager().getAuthToken();
      Dio dio = Dio();
      List<ResponseOffline> resOff = await fetchResponsesLocal();

      for (var element in resOff) {
        final x = element.toMap();
        list.add({
          "exam_id": x["examId"],
          "student_number": x["studentNumber"],
          "answer": x["answer"],
          "score": x["score"],
          "detected": x["detected"],
          "image_path": x["imagePath"]
        });
      }

      final x = await dio.post(ApiEndpoints.syncResponse,
          data: {"responses": list},
          options: Options(headers: {'Authorization': token}));

      print(x);
    } catch (error) {
      print("HEY");
      print(error);
    }
  }

  Future<List<ResponseOffline>> fetchResponsesWithFallback() async {
    List<ResponseOffline> responses = [];

    try {
      await syncResponses()
          .whenComplete(() async => {responses = await fetchResponses()});
    } on DioException {
      print("HEY");
      ToastHelper.showToast("You are offline. Local data has been loaded.");
      return fetchResponsesLocal();
    } catch (error) {
      print("SHI");
      ToastHelper.showToast("You are offline. Local data has been loaded.");
      return fetchResponsesLocal();
    }

    return responses;
  }

  Future<List<ResponseOffline>> fetchResponsesLocal() async {
    try {
      final db = await DatabaseHelper().database;

      final List<Map<String, dynamic>> maps = await db.query('responses');
      return List.generate(maps.length, (i) {
        return ResponseOffline.fromMap(maps[i]);
      });
    } catch (error) {
      return Future.error("Database fallback failed.");
    }
  }

  Future<List<ResponseOffline>> fetchResponses() async {
    final List<ResponseOffline> list = [];
    final Dio dio = Dio();
    final token = await TokenManager().getAuthToken();

    final res = await dio.get(ApiEndpoints.responses,
        data: {"exam_id": widget.examId},
        options: Options(headers: {'Authorization': token}));

    if (res.statusCode == 200) {
      final responses = res.data["responses"] ?? [];
      final db = await DatabaseHelper().database;

      for (var response in responses) {
        final attr = response["attributes"];
        final jsonUser = attr["user"];

        ResponseOffline resOffline = ResponseOffline(
            id: attr["id"],
            examId: attr["exam_id"],
            studentNumber: attr["student_number"],
            imagePath: attr["image_path"],
            detected: attr["detected"],
            score: attr["score"],
            answer: attr["answer"],
            createdAt: DateTime.parse(attr["created_at"]),
            name: jsonUser["name"],
            email: jsonUser["email"]);

        list.add(resOffline);
      }

      await db.transaction((txn) async {
        // Clear the table
        await txn.delete('responses'); // This will remove all rows
        // Insert new data
        for (var data in list) {
          await txn.insert('responses', data.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      });
    } else {
      return Future.error("Something went wrong");
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(41, 46, 50, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(101, 188, 80, 1),
        title: const Text("View Responses"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
          padding: EdgeInsets.all(12),
          child: FutureBuilder<List<ResponseOffline>>(
              future: fetchResponsesWithFallback(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text("Something went wrong.",
                            style: TextStyle(color: Colors.white)));
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Center(
                          child: Column(children: [
                        Image.asset('assets/images/empty.gif',
                            width: 300, height: 300),
                        const Text("No responses yet.",
                            style: TextStyle(color: Colors.white))
                      ]));
                    }

                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return _buildCard(snapshot.data![index]);
                        });
                  }
                }

                return const Center(child: CircularProgressIndicator());
              })),
    );
  }

  void tapResponse(ResponseOffline response, Exam exam) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultsScreen(
                existingResponse: response,
                answer: response.answer.split(""),
                studentId: response.studentNumber,
                exam: exam,
                answerKey: exam.answerKey.split(""))));
  }

  Widget _buildCard(ResponseOffline response) {
    return Card(
      child: ListTile(
          onTap: () {
            tapResponse(response, widget.exam);
          },
          title: Column(
            children: [
              Text(response.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Student No.: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(response.studentNumber)
                ],
              )
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              Row(
                children: [
                  Text("Score: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(response.score.toString())
                ],
              ),
              Row(
                children: [
                  Text("Detected: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(response.detected.toString())
                ],
              ),
              const SizedBox(height: 16),
              Text(DateFormat('MMMM d, y \'at\' h:mm a')
                  .format(response.createdAt))
            ],
          )),
    );
  }
}
