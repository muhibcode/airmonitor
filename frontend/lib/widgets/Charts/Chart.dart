import 'package:air_monitor/widgets/Charts/DayChart.dart';
import 'package:air_monitor/widgets/Charts/HourChart.dart';
import 'package:flutter/material.dart';

import '../../config.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  showData() {
    var route = ModalRoute.of(context)!.settings.arguments as Map;
    if (route['time'] == 'hour') {
      return HourChart(routeVal: route['val']);
    } else {
      return DayChart(routeVal: route['val']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: primaryColor, body: showData());
  }
}
