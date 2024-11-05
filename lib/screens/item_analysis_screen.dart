import 'package:flutter/material.dart';
import 'package:scannerv3/helpers/database_helper.dart';
import 'package:scannerv3/models/offline/response_offline.dart';
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
  double pass = 0;
  double fail = 0;
  int lowestScore = 0;
  int highesScore = 0;
  double avg = 0;
  double median = 0;

  Future<List<ResponseOffline>> fetchResponsesLocal() async {
    try {
      final db = await DatabaseHelper().database;

      // Query the table for all the exams.
      final List<Map<String, dynamic>> maps = await db
          .query('responses', where: "examId = ?", whereArgs: [widget.examId]);

      var list = List.generate(maps.length, (i) {
        return ResponseOffline.fromMap(maps[i]);
      });

      // setPassingRate(list);

      return list;
    } catch (error) {
      return Future.error("Database fallback failed.");
    }
  }

  void setPassingRate(List<ResponseOffline> ro) {
    int passInt = 0;
    int low = 0;
    int high = 0;
    int total = 0;

    for (var x in ro) {
      if (x.score >= 25) {
        pass += 1;
      }

      if (low != 0) {
        if (low > x.score) {
          low = x.score;
        }
      } else {
        low = x.score;
      }

      if (high != 0) {
        if (high < x.score) {
          high = x.score;
        }
      } else {
        high = x.score;
      }

      total += x.score;
    }

    var passPercent = ((passInt / 50) * 100) * 100;
    setState(() {
      pass = passPercent;
      fail = 100 - passPercent;
      lowestScore = low;
      highesScore = high;
      avg = total / ro.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Item Analysis")),
      body: FutureBuilder(
          future: fetchResponsesLocal(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // if error has seen
              print(snapshot.error);
              return Text("Error");
            }

            return Column(
              children: [
                StatisticsWidget(
                    pass: 70, fail: 30, low: 12, high: 15, avg: 13),
                ItemAnalysisWidget(),
                ScoreDistWidget()
              ],
            );
          }),
    );
  }
}
