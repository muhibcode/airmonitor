import 'package:air_monitor/API.dart';
import 'package:air_monitor/widgets/Storage.dart';
import 'package:air_monitor/widgets/controller/HomeController.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config.dart';

class DayChart extends StatefulWidget {
  final routeVal;
  const DayChart({
    super.key,
    this.routeVal,
  });

  @override
  State<DayChart> createState() => _DayChartState();
}

class _DayChartState extends State<DayChart> {
  var controller = Get.put(HomeController());

  @override
  void initState() {
    controller.decTime();
    getData();
    super.initState();
  }

  String tNow = '';
  String tFour = '';
  String tNine = '';
  String tForteen = '';
  String tNineteen = '';
  String tTwenFour = '';
  String tTwenNine = '';

  String tZero = '';

  double twen_nine = 0;
  double four = 0;
  double nine = 0;
  double forteen = 0;
  double nineteen = 0;
  double twen_four = 0;
  String name = '';

  var newData = List.empty(growable: true);

  setTime(String t) {
    var tRes = t.split(' ')[0];

    var fT = t.split(' ')[1];

    var newTime = tRes + fT;

    return newTime;
  }

  getData() async {
    var d = getlocData('data');
    var params = {'mac_add': d['mac_add']};

    var res = await getWithParams('last_24hour_chart', params);
    var data = res.data;

    for (var i in data) {
      setState(() {
        name = i['four'][widget.routeVal]['name'];
        if (i['four'][widget.routeVal]['max_value'] != null) {
          four =
              double.parse(i['four'][widget.routeVal]['max_value'].toString());
        }
        if (i['nine'][widget.routeVal]['max_value'] != null) {
          nine =
              double.parse(i['nine'][widget.routeVal]['max_value'].toString());
        }
        if (i['forteen'][widget.routeVal]['max_value'] != null) {
          forteen = double.parse(
              i['forteen'][widget.routeVal]['max_value'].toString());
        }

        if (i['nineteen'][widget.routeVal]['max_value'] != null) {
          nineteen = double.parse(
              i['nineteen'][widget.routeVal]['max_value'].toString());
        }
        if (i['twen_four'][widget.routeVal]['max_value'] != null) {
          twen_four = double.parse(
              i['twen_four'][widget.routeVal]['max_value'].toString());
        }
        if (i['twen_nine'][widget.routeVal]['max_value'] != null) {
          twen_nine = double.parse(
              i['twen_nine'][widget.routeVal]['max_value'].toString());
        }

        tFour = setTime(i['four'][4]['time']);
        tNine = setTime(i['nine'][4]['time']);
        tForteen = setTime(i['forteen'][4]['time']);
        tNineteen = setTime(i['nineteen'][4]['time']);
        tTwenFour = setTime(i['twen_four'][4]['time']);
        tTwenNine = setTime(i['twen_nine'][4]['time']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Last 24 Hours'),
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
            width: 420,
            color: Colors.green[800],
            child: LineChart(LineChartData(
                backgroundColor: primaryColor,
                minX: 0,
                maxX: 25,
                minY: 0,
                maxY: 5000,
                titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                        drawBelowEverything: false,
                        axisNameWidget: const Text('HOURS'),
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            String text = '';
                            switch (value.toInt()) {
                              case 0:
                                text = tFour;
                                break;
                              case 5:
                                text = tNine;
                                break;
                              case 10:
                                text = tForteen;
                                break;
                              case 15:
                                text = tNineteen;
                                break;
                              case 20:
                                text = tTwenFour;
                                break;
                              case 25:
                                text = tTwenNine;
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
                      // color: four > 300 ? activeColor2 : Colors.orange,
                      color: Colors.orange,
                      isCurved: false,
                      spots: [
                        FlSpot(0, four),
                        FlSpot(5, nine),
                        FlSpot(10, forteen),
                        FlSpot(15, nineteen),
                        FlSpot(20, twen_four),
                        FlSpot(25, twen_nine),
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
                  twen_nine = 0;
                  four = 0;
                  nine = 0;
                  forteen = 0;
                  nineteen = 0;
                  twen_four = 0;
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
