import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:scannerv3/camera_screen.dart';
import 'package:scannerv3/models/exam.dart';
import 'package:scannerv3/screens/answer_key_screen.dart';
import 'package:scannerv3/screens/results_screen.dart';
import 'package:scannerv3/utils/answer_key_decoder.dart';

class ExamScreen extends StatelessWidget {
  final Exam exam;

  const ExamScreen({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> buttonData = [
      {
        'label': 'Scan Paper',
        'icon': Icons.document_scanner_outlined,
        'route': CameraScreen(exam: exam)
      },
      {
        'label': 'View Answer Key',
        'icon': Iconsax.key,
        'route': AnswerKeyScreen(
            answerKey: AnswerKeyDecoder().decodeKey(exam.answerKey))
      },
      {'label': 'View Responses', 'icon': Icons.list_alt},
      {'label': 'Item Analysis', 'icon': Icons.analytics},
      {'label': 'Statistics', 'icon': Iconsax.graph},
      {'label': 'Item Frequency', 'icon': Icons.timeline},
    ];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(41, 46, 50, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(101, 188, 80, 1),
        title: const Text("Exam Menu"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromRGBO(101, 188, 80, 1),
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text("Exam Name:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(exam.name)
                ]),
                Row(children: [
                  Text("Responses:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(12.toString())
                ]),
                SizedBox(height: 12),
                Text(exam.quarter.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Divider(),
                Text(exam.subject.name,
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Expanded(
              child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two columns
              childAspectRatio: 1, // Aspect ratio for tiles
            ),
            itemCount: buttonData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    buttonData[index]['route']));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              buttonData[index]['icon'],
                              size: 40,
                            ),
                            SizedBox(height: 8),
                            Text(
                              buttonData[index]['label'],
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )),
              );
            },
          ))
        ],
      ),
    );
  }
}
