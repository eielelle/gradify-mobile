import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scannerv3/helpers/database_helper.dart';
import 'package:scannerv3/models/offline/response_offline.dart';
import 'package:scannerv3/utils/token_manager.dart';
import 'package:scannerv3/values/api_endpoints.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class ViewResponsesScreen extends StatefulWidget {
  final int examId;

  const ViewResponsesScreen({super.key, required this.examId});

  @override
  State<ViewResponsesScreen> createState() => _ViewResponsesScreenState();
}

class _ViewResponsesScreenState extends State<ViewResponsesScreen> {
  final List<ResponseOffline> list = [];
  String _errorMessage = "";
  bool _loading = false;
  final Dio _dio = Dio();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchResponses();
  }

  Future<void> fetchResponses() async {
    setState(() {
      _loading = true;
    });

    try {
      final token = await TokenManager().getAuthToken();
      if (token != null) {
        final res = await _dio.get(ApiEndpoints.responses,
            data: {"exam_id": widget.examId},
            options: Options(headers: {'Authorization': token}));

        if (res.statusCode == 200) {
          final responses = res.data["responses"] ?? [];

          for (var response in responses) {
            final attr = response["attributes"];
            final jsonUser = attr["user"];

            ResponseOffline resOffline = ResponseOffline(
                attr["id"],
                attr["exam_id"],
                attr["user_id"],
                attr["student_number"],
                attr["image_path"],
                attr["detected"],
                attr["score"],
                attr["answer"],
                DateTime.parse(attr["created_at"]),
                name: jsonUser["name"],
                email: jsonUser["email"]);

            // insert to db for offline access
            final db = await DatabaseHelper().database;
            db.insert('responses', resOffline.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace);

            setState(() {
              list.add(resOffline);
            });
          }

          setState(() {
            _loading = false;
          });
        }
      }
    } on DioException catch (error) {
      // Handle errors from Dio
      setState(() {
        _errorMessage =
            error.response?.data['errors'][0] ?? 'Error fetching data';
        _loading = false;
      });

      _showDialog("Fetch error", _errorMessage);
    }
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
          child: Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return _buildResponse(list[index]);
                      }))),
    );
  }

  void tapResponse() {}

  Widget _buildResponse(ResponseOffline response) {
    return Card(
      child: ListTile(
          onTap: () {
            // tapResponse(sc);
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
