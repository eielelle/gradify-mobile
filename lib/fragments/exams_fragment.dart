import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:opencv_dart/opencv_dart.dart';
import 'package:scannerv3/models/exam.dart';
import 'package:scannerv3/models/quarter.dart';
import 'package:scannerv3/models/school_exam.dart';
import 'package:scannerv3/models/subject.dart';
import 'package:scannerv3/utils/token_manager.dart';
import 'package:scannerv3/values/api_endpoints.dart';

class ExamsFragment extends StatefulWidget {
  const ExamsFragment({super.key});

  @override
  State<ExamsFragment> createState() => _ExamsFragmentState();
}

class _ExamsFragmentState extends State<ExamsFragment> {
  final List<Exam> list = [];
  String _errorMessage = "";
  bool _loading = false;
  final Dio _dio = Dio();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchExams();
  }

  Future<void> fetchExams() async {
    setState(() {
      _loading = true;
    });

    try {
      final token = await TokenManager().getAuthToken();
      if (token != null) {
        final res = await _dio.get(ApiEndpoints.getExams,
            options: Options(headers: {'Authorization': token}));

        if (res.statusCode == 200) {
          final exams = res.data["exams"] ?? [];

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

            setState(() {
              _loading = false;

              list.add(Exam(quarter, subject,
                  id: attr["id"],
                  name: attr["name"],
                  answerKey: attr["answer_key"],
                  createdAt: DateTime.parse(attr["created_at"])));
            });
          }
        }
      }
    } on DioException catch (error) {
      // Handle errors from Dio
      setState(() {
        _errorMessage =
            error.response?.data['errors'][0] ?? 'Error fetching data';
        _loading = false;
      });

      _showErrorDialog(_errorMessage);
    }
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
        children: [
          const Row(
            children: [
              Expanded(
                  child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintStyle:
                        TextStyle(color: Color.fromRGBO(187, 187, 187, 1)),
                    hintText: "Search",
                    fillColor: Color.fromRGBO(50, 57, 62, 1),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.green), // Border when enabled
                    ),
                    filled: true),
              ))
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return _buildCard(list[index]);
                      }))
        ],
      ),
    );
  }

  Widget _buildCard(Exam sc) {
    return Card(
      child: ListTile(
          title: Text(sc.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(sc.quarter.name),
              const Divider(),
              Text(sc.subject.name)
            ],
          )),
    );
  }
}
