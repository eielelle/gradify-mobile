import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scannerv3/models/school_year.dart';
import 'package:scannerv3/models/section.dart';
import 'package:scannerv3/models/student.dart';
import 'package:scannerv3/utils/token_manager.dart';
import 'package:scannerv3/values/api_endpoints.dart';

class StudentScreen extends StatefulWidget {
  final int sectionId;

  const StudentScreen({super.key, required this.sectionId});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<Student>> fetchStudents() async {
    final List<Student> list = [];
    final dio = Dio();
    final token = await TokenManager().getAuthToken();
    final res = await dio.get(ApiEndpoints.students,
        data: {"section_id": widget.sectionId},
        options: Options(headers: {'Authorization': token}));

    if (res.statusCode == 200) {
      final students = res.data["students"] ?? [];

      for (var student in students) {
        final attr = student["attributes"];
        final stud = Student(attr["name"], attr["student_number"]);

        list.add(stud);
      }

      return list;
    } else {
      throw Exception('Failed to load posts');
    }
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
                    future: fetchStudents(),
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
