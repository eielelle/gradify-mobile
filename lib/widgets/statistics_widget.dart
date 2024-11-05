import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:scannerv3/models/offline/response_offline.dart';

class StatisticsWidget extends StatelessWidget {
  final double pass, fail, avg;
  final int low, high;

  const StatisticsWidget(
      {super.key,
      required this.pass,
      required this.fail,
      required this.avg,
      required this.low,
      required this.high});

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (index) {
      switch (index) {
        case 0:
          return PieChartSectionData(
            color: Colors.green,
            value: pass,
            title: '$pass%',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: fail,
            title: '$fail%',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Card(
                    child: Container(
                        padding: EdgeInsets.all(12),
                        child: Column(children: [
                          Text("Passing Rate",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          SizedBox(height: 12),
                          AspectRatio(
                              aspectRatio: 1.5,
                              child: PieChart(
                                PieChartData(
                                  sections: showingSections(),
                                ),
                              ))
                        ])))),
            Expanded(
                child: Card(
                    child: Container(
                        padding: EdgeInsets.all(12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Statistics",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Row(children: [
                                Text("Lowest Score: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(low.toString())
                              ]),
                              Row(children: [
                                Text("Highest Score: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(high.toString())
                              ]),
                              Row(children: [
                                Text("Average: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(avg.toString())
                              ]),
                              // Row(children: [
                              //   Text("Median: ",
                              //       style:
                              //           TextStyle(fontWeight: FontWeight.bold)),
                              //   Text("1")
                              // ]),
                              // Row(children: [
                              //   Text("Std. Deviation: ",
                              //       style:
                              //           TextStyle(fontWeight: FontWeight.bold)),
                              //   Text("1")
                              // ]),
                            ]))))
          ],
        ));
  }
}
