import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:scannerv3/models/exam.dart';

class ResultsScreen extends StatefulWidget {
  final List<String> answer;
  final List<String> answerKey;
  final String studentId;
  final Exam exam;
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setScore();
    setDetected();
  }

  void setDetected() {
    int errorCount = widget.answer.where((char) => char == '?').length;

    setState(() {
      widget.detected = 50 - errorCount;
    });
  }

  void setScore() {
    int score = 0;

    for (int i = 0; i < widget.answer.length; i++) {
      if (widget.answer[i].contains(widget.answerKey[i])) {
        score++;
      }
    }

    print("SCORE: ${score}");

    setState(() {
      widget.score = score;
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
                  Text(widget.exam.name)
                ]),
                Row(children: [
                  Text("Responses:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(12.toString())
                ]),
                SizedBox(height: 12),
                Text(widget.exam.quarter.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Divider(),
                Text(widget.exam.subject.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("Student ID: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.studentId),
                    IconButton(onPressed: () {}, icon: Icon(Iconsax.edit))
                  ],
                ),
                Row(
                  children: [
                    Text("Detected Bubbles: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("${widget.detected}/50"),
                  ],
                ),
                Row(
                  children: [
                    Text("Score: ",
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
                                style: TextStyle(
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
