import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scannerv3/models/school_year.dart';
import 'package:scannerv3/models/section.dart';
import 'package:scannerv3/models/student.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final List<Student> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchStudent();
  }

  void fetchStudent() {
    setState(() {
      list.add(Student("John Doe", "00002"));
      list.add(Student("Jane Doe", "00001"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Student List")),
        body: Expanded(
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return _buildCard(list[index]);
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
        Text(student.student_number)
      ],
    )));
  }
}
