import 'package:flutter/material.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:lottie/lottie.dart';

import '../global.dart';
import '../models/chart_model.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  List<charts.Series<ChartData, String>> createChartSeries() {
    // Convert the allItems list into ChartData objects
    List<ChartData> chartDataList = allItems.map((item) {
      String subject = item.subject;
      DateTime startTime = item.startTime;
      DateTime endTime = item.endTime;
      int duration = endTime.difference(startTime).inHours;

      return ChartData(subject, duration);
    }).toList();

    // Create a chart series
    return [
      charts.Series<ChartData, String>(
        id: 'Time Duration',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ChartData data, _) => data.subject,
        measureFn: (ChartData data, _) => data.duration,
        data: chartDataList,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ChartData, String>> seriesList = createChartSeries();

    return allItems.isEmpty
        ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lottie files/welcome.json'),
                  const Text('Waiting to ADD Schedules'),
                ],
              ),
            )
        : Column(
            children: [
              Text('Schedule Chart'),
              Expanded(
                child: charts.BarChart(
                  seriesList,
                  animate: true,
                  vertical: false,
                ),
              ),
            ],
          );
  }
}
