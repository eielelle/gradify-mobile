import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scannerv3/helpers/database_helper.dart';
import 'package:scannerv3/models/student.dart';
import 'package:scannerv3/utils/token_manager.dart';
import 'package:scannerv3/values/api_endpoints.dart';
import 'package:sqflite/sqflite.dart';

class StudentScreen extends StatefulWidget {
  final int sectionId;

  const StudentScreen({super.key, required this.sectionId});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  Future<List<Student>> fetchStudentsLocal() async {
    try {
      final db = await DatabaseHelper().database;

      // Query the table for all the exams.
      final List<Map<String, dynamic>> maps = await db.query('students');

      return List.generate(maps.length, (i) {
        return Student.fromMap(maps[i]);
      });
    } catch (error) {
      return Future.error("Database fallback failed.");
    }
  }

  Future<List<Student>> fetchStudentsWithFallback() async {
    List<Student> exams = [];

    try {
      exams = await fetchStudents();
    } on DioException {
      _showErrorDialog("Cannot sync to web. Loading local data instead.");
      return fetchStudentsLocal();
    } catch (error) {
      _showErrorDialog("Cannot sync to web. Loading local data instead.");
      return fetchStudentsLocal();
    }

    return exams;
  }

  Future<List<Student>> fetchStudents() async {
    final List<Student> list = [];
    final dio = Dio();
    final db = await DatabaseHelper().database;
    final token = await TokenManager().getAuthToken();
    final res = await dio.get(ApiEndpoints.students,
        data: {"section_id": widget.sectionId},
        options: Options(headers: {'Authorization': token}));

    if (res.statusCode == 200) {
      final students = res.data["students"] ?? [];

      for (var student in students) {
        final attr = student["attributes"];
        final stud =
            Student(name: attr["name"], student_number: attr["student_number"]);

        list.add(stud);
      }

      await db.transaction((txn) async {
        // Clear the table
        await txn.delete('students'); // This will remove all rows
        // Insert new data
        for (var data in list) {
          await txn.insert('students', data.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      });
    } else {
      return Future.error("Something went wrong");
    }

    return list;
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
    return Scaffold(
        backgroundColor: const Color.fromRGBO(41, 46, 50, 1),
        appBar: AppBar(
            backgroundColor: const Color.fromRGBO(101, 188, 80, 1),
            title: const Text("Student List"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Container(
            padding: EdgeInsets.all(12),
            child: Expanded(
                child: FutureBuilder<List<Student>>(
                    future: fetchStudentsWithFallback(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        // if error has seen
                        print(snapshot.error);
                      }

                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return _buildCard(snapshot.data![index]);
                          });
                    }))));
  }

  Widget _buildCard(Student student) {
    return Card(
        child: ListTile(
            title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          student.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Divider(),
        Text("ID: ${student.student_number}")
      ],
    )));
  }
}
