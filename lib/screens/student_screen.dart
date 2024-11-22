import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:scannerv3/helpers/database_helper.dart';
import 'package:scannerv3/helpers/toast_helper.dart';
import 'package:scannerv3/models/student.dart';
import 'package:scannerv3/screens/home_screen.dart';
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
      ToastHelper.showToast("You are offline. Local data has been loaded.");
      return fetchStudentsLocal();
    } catch (error) {
      ToastHelper.showToast("You are offline. Local data has been loaded.");
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
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Iconsax.home,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false);
              },
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.all(12),
            child: FutureBuilder<List<Student>>(
                future: fetchStudentsWithFallback(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // if error has seen
                    return const Center(
                        child: Text("Something went wrong.",
                            style: TextStyle(color: Colors.white)));
                  }

                  if (snapshot.data!.isEmpty) {
                    return Center(
                        child: Column(children: [
                      Image.asset('assets/images/empty.gif',
                          width: 300, height: 300),
                      const Text("No classes assigned yet.",
                          style: TextStyle(color: Colors.white))
                    ]));
                  }

                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return _buildCard(snapshot.data![index]);
                      });
                })));
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
