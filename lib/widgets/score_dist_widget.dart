import 'package:flutter/material.dart';

class ScoreDistWidget extends StatefulWidget {
  const ScoreDistWidget({super.key});

  @override
  State<ScoreDistWidget> createState() => _ScoreDistWidgetState();
}

class _ScoreDistWidgetState extends State<ScoreDistWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: EdgeInsets.all(12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Score Distribution (In Percent)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Row(children: [
                Text("90 - 100: ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
                Text("1")
              ]),
              Row(children: [
                Text("80 - 89: ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.lightGreen)),
                Text("1")
              ]),
              Row(children: [
                Text("75 - 79: ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.yellow)),
                Text("1")
              ]),
              Row(children: [
                Text("60 - 74: ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.orange)),
                Text("1")
              ]),
              Row(children: [
                Text("60 below: ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
                Text("1")
              ]),
            ])));
  }
}
