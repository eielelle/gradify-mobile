import 'package:flutter/material.dart';

class EditResponseScreen extends StatefulWidget {
  List<String> answer;
  final List<String> answerKey;
  final Function(String, int) updateAnswer;

  EditResponseScreen(
      {super.key,
      required this.answer,
      required this.answerKey,
      required this.updateAnswer});

  @override
  State<EditResponseScreen> createState() => _EditResponseScreenState();
}

class _EditResponseScreenState extends State<EditResponseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(41, 46, 50, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(101, 188, 80, 1),
        title: const Text("Edit Response"),
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
                  itemCount: widget.answer.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Text("${index + 1}: ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.white)),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.updateAnswer("A", index);
                                  });
                                },
                                child: _buildBubble("A", index)),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.updateAnswer("B", index);
                                  });
                                },
                                child: _buildBubble("B", index)),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.updateAnswer("C", index);
                                  });
                                },
                                child: _buildBubble("C", index)),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.updateAnswer("D", index);
                                  });
                                },
                                child: _buildBubble("D", index)),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.updateAnswer("E", index);
                                  });
                                },
                                child: _buildBubble("E", index)),
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
