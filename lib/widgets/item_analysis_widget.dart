import 'package:flutter/material.dart';
import 'package:scannerv3/models/offline/response_offline.dart';

class ItemAnalysisWidget extends StatefulWidget {
  final List<ResponseOffline> ro;
  final List<String> answerKey;

  const ItemAnalysisWidget(
      {super.key, required this.ro, required this.answerKey});

  @override
  State<ItemAnalysisWidget> createState() => _ItemAnalysisWidgetState();
}

class _ItemAnalysisWidgetState extends State<ItemAnalysisWidget> {
  @override
  Widget build(BuildContext context) {
    List<int> freq = List.generate(50, (index) => 0);

    for (int i = 1; i <= 50; i++) {
      int correct = 0;

      for (var x in widget.ro) {
        if (x.answer.split("")[i - 1] == widget.answerKey[i - 1]) {
          correct += 1;
        }
      }

      freq[i - 1] = correct;
    }

    return Column(
      children: [
        Text(
          "Item Analysis",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SingleChildScrollView(
            // scrollDirection: Axis.horizontal,
            child: Container(
                width: 700,
                child: Table(
                    border: TableBorder.all(color: Colors.white),
                    children: [
                      showHeader(),
                      for (int i = 1; i <= 50; i++)
                        TableRow(children: [
                          Text(
                            i.toString(),
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            freq.length >= 50 ? freq[i - 1].toString() : "",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          // Text(""),
                          // Text("")
                        ])
                    ])))
      ],
    );
  }

  TableRow showHeader() {
    return TableRow(children: [
      Text(
        "Item No.",
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
      Text(
        "Frequency of Correct Answers",
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
      // Text("Item Difficulty", style: TextStyle(color: Colors.white)),
      // Text("Item Discrimination", style: TextStyle(color: Colors.white))
    ]);
  }
}
