import 'package:air_monitor/API.dart';
import 'package:air_monitor/widgets/Storage.dart';
import 'package:air_monitor/widgets/controller/HomeController.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config.dart';

class HourChart extends StatefulWidget {
  final routeVal;
  const HourChart({
    super.key,
    this.routeVal,
  });

  @override
  State<HourChart> createState() => _HourChartState();
}

class _HourChartState extends State<HourChart> {
  var controller = Get.put(HomeController());

  String tNow = '';
  String tFifty = '';
  String tForty = '';
  String tThirty = '';
  String tTwenty = '';
  String tTen = '';
  String tZero = '';

  @override
  void initState() {
    controller.decTime();
    getData();
    super.initState();
  }

  double now = 0;
  double fifty = 0;
  double forty = 0;
  double thirty = 0;
  double twenty = 0;
  double ten = 0;
  double zero = 0;
  String name = '';

  double avg = 0;
  int favg = 0;

  var newData = List.empty(growable: true);

  getData() async {
    var d = getlocData('data');

    var params = {'mac_add': d['mac_add']};
    var res = await getWithParams('last_hour_chart', params);
    var data = res.data;

    for (var i in data) {
      setState(() {
        name = i['now'][widget.routeVal]['name'];
        if (i['now'][widget.routeVal]['max_value'] != null) {
          now = double.parse(i['now'][widget.routeVal]['max_value'].toString());
        }
        if (i['fifty'][widget.routeVal]['max_value'] != null) {
          fifty =
              double.parse(i['fifty'][widget.routeVal]['max_value'].toString());
        }
        if (i['forty'][widget.routeVal]['max_value'] != null) {
          forty =
              double.parse(i['forty'][widget.routeVal]['max_value'].toString());
        }
        if (i['thirty'][widget.routeVal]['max_value'] != null) {
          thirty = double.parse(
              i['thirty'][widget.routeVal]['max_value'].toString());
        }
        if (i['twenty'][widget.routeVal]['max_value'] != null) {
          twenty = double.parse(
              i['twenty'][widget.routeVal]['max_value'].toString());
        }
        if (i['ten'][widget.routeVal]['max_value'] != null) {
          ten = double.parse(i['ten'][widget.routeVal]['max_value'].toString());
        }

        tNow = i['now'][4]['time'].toString().split(' ')[0];
        tFifty = i['fifty'][4]['time'].toString().split(' ')[0];
        tForty = i['forty'][4]['time'].toString().split(' ')[0];
        tThirty = i['thirty'][4]['time'].toString().split(' ')[0];
        tTwenty = i['twenty'][4]['time'].toString().split(' ')[0];
        tTen = i['ten'][4]['time'].toString().split(' ')[0];
        tZero = i['zero'][4]['time'].toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Last One Hour'),
        backgroundColor: activeColor2,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            name,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 450,
            width: 400,
            color: Colors.orange[900],
            child: LineChart(LineChartData(
                backgroundColor: primaryColor,
                minX: 0,
                maxX: 60,
                minY: 0,
                maxY: 5000,
                titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                        drawBelowEverything: false,
                        axisNameWidget: const Text('MINUTES'),
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            String text = '';

                            switch (value.toInt()) {
                              case 0:
                                text = tNow;
                                break;
                              case 10:
                                text = tFifty;
                                break;
                              case 20:
                                text = tForty;
                                break;
                              case 30:
                                text = tThirty;
                                break;
                              case 40:
                                text = tTwenty;
                                break;
                              case 50:
                                text = tTen;
                                break;
                              case 60:
                                text = tZero;
                                break;
                            }
                            return Text(text);
                          },
                        ))),
                gridData: FlGridData(
                  show: true,
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                        color: Color(0xff37434d), strokeWidth: 1);
                  },
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                        color: Color(0xff37434d), strokeWidth: 1);
                  },
                ),
                borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xff37434d))),
                lineBarsData: [
                  LineChartBarData(
                      color: now > 300 ? activeColor2 : Colors.greenAccent,
                      isCurved: false,
                      spots: [
                        FlSpot(0, now),
                        FlSpot(10, fifty),
                        FlSpot(20, forty),
                        FlSpot(30, thirty),
                        FlSpot(40, twenty),
                        FlSpot(50, ten),
                        FlSpot(60, zero),
                      ]),
                ])),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                      const Size.fromHeight(10)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              onPressed: () {
                setState(() {
                  now = 0;
                  fifty = 0;
                  forty = 0;
                  thirty = 0;
                  twenty = 0;
                  ten = 0;
                  zero = 0;
                });
                getData();
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.black,
              ),
              label: const Text(
                'Refresh',
                style: TextStyle(color: Colors.black, fontSize: 20),
              )),
        ],
      ),
    );
  }
}
