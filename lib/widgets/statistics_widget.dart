import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatisticsWidget extends StatelessWidget {
  const StatisticsWidget({super.key});

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (index) {
      switch (index) {
        case 0:
          return PieChartSectionData(
            color: Colors.green,
            value: 40,
            title: '40%',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: 60,
            title: '60%',
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
                                Text("1")
                              ]),
                              Row(children: [
                                Text("Highest Score: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("1")
                              ]),
                              Row(children: [
                                Text("Average: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("1")
                              ]),
                              Row(children: [
                                Text("Median: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("1")
                              ]),
                              Row(children: [
                                Text("Std. Deviation: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("1")
                              ]),
                            ]))))
          ],
        ));
  }
}
