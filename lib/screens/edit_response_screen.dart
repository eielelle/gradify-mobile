import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scannerv3/helpers/toast_helper.dart';

class EditResponseScreen extends StatefulWidget {
  List<String> answer;
  final List<String> answerKey;
  final Function(List<String>) updateAnswer;

  EditResponseScreen(
      {super.key,
      required this.answer,
      required this.answerKey,
      required this.updateAnswer});

  @override
  State<EditResponseScreen> createState() => _EditResponseScreenState();
}

class _EditResponseScreenState extends State<EditResponseScreen> {
  List<String> editedAnswer = [];

  void updateEditAnswer(String label, int index) {
    setState(() {
      editedAnswer[index] = label;
    });
  }

  void edit() {
    widget.updateAnswer(editedAnswer);
    Navigator.pop(context);
    ToastHelper.showToast("Updated answer");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      editedAnswer = List.from(widget.answer);
    });
  }

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
          Container(
              padding: EdgeInsets.all(12),
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    edit();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color.fromRGBO(101, 188, 80, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Set border radius
                    ),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white),
                  ))),
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
                                    updateEditAnswer("A", index);
                                  });
                                },
                                child: _buildBubble("A", index)),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    updateEditAnswer("B", index);
                                  });
                                },
                                child: _buildBubble("B", index)),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    updateEditAnswer("C", index);
                                  });
                                },
                                child: _buildBubble("C", index)),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    updateEditAnswer("D", index);
                                  });
                                },
                                child: _buildBubble("D", index)),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    updateEditAnswer("E", index);
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
    bool isKey = editedAnswer[index].contains(label);
    bool isCorrect = editedAnswer[index].contains(widget.answerKey[index]);

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
