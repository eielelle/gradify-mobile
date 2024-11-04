import 'package:flutter/material.dart';
import 'package:scannerv3/widgets/item_analysis_widget.dart';
import 'package:scannerv3/widgets/score_dist_widget.dart';
import 'package:scannerv3/widgets/statistics_widget.dart';

class ItemAnalysisScreen extends StatefulWidget {
  final int examId;

  const ItemAnalysisScreen({super.key, required this.examId});

  @override
  State<ItemAnalysisScreen> createState() => _ItemAnalysisScreenState();
}

class _ItemAnalysisScreenState extends State<ItemAnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Item Analysis")),
      body: Column(
        children: [StatisticsWidget(), ItemAnalysisWidget(), ScoreDistWidget()],
      ),
    );
  }
}
