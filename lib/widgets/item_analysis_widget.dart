import 'package:flutter/material.dart';

class ItemAnalysisWidget extends StatefulWidget {
  const ItemAnalysisWidget({super.key});

  @override
  State<ItemAnalysisWidget> createState() => _ItemAnalysisWidgetState();
}

class _ItemAnalysisWidgetState extends State<ItemAnalysisWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Item Analysis"),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:
                Container(width: 700, child: Table(children: [showHeader()])))
      ],
    );
  }

  TableRow showHeader() {
    return TableRow(children: [
      Text("Item No."),
      Text("Frequency of Correct Answers"),
      Text("Item Difficulty"),
      Text("Item Discrimination")
    ]);
  }
}
