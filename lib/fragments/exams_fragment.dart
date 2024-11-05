import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scannerv3/helpers/database_helper.dart';
import 'package:scannerv3/models/exam.dart';
import 'package:scannerv3/models/quarter.dart';
import 'package:scannerv3/models/subject.dart';
import 'package:scannerv3/screens/exam_screen.dart';
import 'package:scannerv3/utils/token_manager.dart';
import 'package:scannerv3/values/api_endpoints.dart';
import 'package:sqflite/sqflite.dart';

class ExamsFragment extends StatefulWidget {
  const ExamsFragment({super.key});

  @override
  State<ExamsFragment> createState() => _ExamsFragmentState();
}

class _ExamsFragmentState extends State<ExamsFragment> {
  Future<List<Exam>> fetchExamsLocal() async {
    try {
      final db = await DatabaseHelper().database;

      // Query the table for all the exams.
      final List<Map<String, dynamic>> maps = await db.query('exams');

      return List.generate(maps.length, (i) {
        return Exam.fromMap(maps[i]);
      });
    } catch (error) {
      return Future.error("Database fallback failed.");
    }
  }

  Future<List<Exam>> fetchExamsWithFallback() async {
    List<Exam> exams = [];

    try {
      exams = await fetchExams();
    } on DioException {
      _showErrorDialog("Cannot sync to web. Loading local data instead.");
      return fetchExamsLocal();
    } catch (error) {
      _showErrorDialog("Cannot sync to web. Loading local data instead.");
      return fetchExamsLocal();
    }

    return exams;
  }

  Future<List<Exam>> fetchExams() async {
    final List<Exam> list = [];
    final Dio dio = Dio();
    final token = await TokenManager().getAuthToken();

    final res = await dio.get(ApiEndpoints.getExams,
        options: Options(headers: {'Authorization': token}));

    if (res.statusCode == 200) {
      final exams = res.data["exams"] ?? [];
      final db = await DatabaseHelper().database;

      for (var exam in exams) {
        final attr = exam["attributes"];
        final jsonQtr = attr["quarter"];
        final jsonSubject = attr["subject"];

        final quarter = Quarter(id: jsonQtr["id"], name: jsonQtr["name"]);
        final subject = Subject(
            id: jsonSubject["id"],
            name: jsonSubject["name"],
            description: jsonSubject["description"],
            createdAt: DateTime.parse(jsonSubject["created_at"]));

        Exam examObj = Exam(
            id: attr['id'],
            name: attr["name"],
            answerKey: attr["answer_key"],
            quarterName: quarter.name,
            subjectName: subject.name,
            responses: attr["responses"],
            createdAt: DateTime.parse(attr['created_at']));

        list.add(examObj);
      }

      await db.transaction((txn) async {
        // Clear the table
        await txn.delete('exams'); // This will remove all rows
        // Insert new data
        for (var data in list) {
          await txn.insert('exams', data.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      });
    } else {
      return Future.error("Something went wrong");
    }

    return list;
  }

  void tapExam(Exam exam) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ExamScreen(exam: exam)));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Fetch Error'),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Your Exams",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
              child: FutureBuilder<List<Exam>>(
                  future: fetchExamsWithFallback(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        if (snapshot.error is DioException) {
                          return const Center(
                              child: Text("DioException Error"));
                        } else {
                          return Center(child: Text(snapshot.error.toString()));
                        }
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return _buildCard(snapshot.data![index]);
                            });
                      }
                    }

                    return const Center(child: CircularProgressIndicator());
                  }))
        ],
      ),
    );
  }

  Widget _buildCard(Exam sc) {
    return Card(
      child: ListTile(
          onTap: () {
            tapExam(sc);
          },
          title: Text(sc.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(sc.quarterName),
              const Divider(),
              Text(sc.subjectName)
            ],
          )),
    );
  }
}
