import 'package:flutter/material.dart';

class AnswerKeyScreen extends StatelessWidget {
  final List<String> answerKey;

  const AnswerKeyScreen({super.key, required this.answerKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Expanded(
              child: ListView.builder(
                  itemCount: answerKey.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Text("${index + 1}: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24)),
                            _buildBubble("A",
                                isKey: answerKey[index].contains("A")),
                            _buildBubble("B",
                                isKey: answerKey[index].contains("B")),
                            _buildBubble("C",
                                isKey: answerKey[index].contains("C")),
                            _buildBubble("D",
                                isKey: answerKey[index].contains("D")),
                            _buildBubble("E",
                                isKey: answerKey[index].contains("E")),
                          ],
                        ));
                  }))
        ],
      ),
    );
  }

  Widget _buildBubble(String label, {bool isKey = false}) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isKey ? Colors.green : Colors.grey,
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
