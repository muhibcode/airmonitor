import 'package:air_monitor/API.dart';
import 'package:air_monitor/widgets/Storage.dart';
import 'package:air_monitor/widgets/controller/HomeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config.dart';

class Last24Hour extends StatefulWidget {
  const Last24Hour({super.key});

  @override
  State<Last24Hour> createState() => _Last24HourState();
}

class _Last24HourState extends State<Last24Hour> {
  var controller = Get.put(HomeController());

  @override
  void initState() {
    controller.decTime();
    getData();
    super.initState();
  }

  var newData = List.empty(growable: true);

  getData() async {
    var d = getlocData('data');
    var params = {'mac_add': d['mac_add']};
    var res = await getWithParams('last_24_hour', params);
    var data = res.data;

    setState(() {
      newData = data;
    });
  }

  showColor(name, val) {
    Color col = Colors.greenAccent;
    if (name == 'CO') {
      if (val != null && val > 1000) {
        col = Colors.red;
      }
    }
    if (name == 'CH4') {
      if (val != null && val > 1000) {
        col = Colors.red;
      }
    }
    if (name == 'LPG') {
      if (val != null && val > 1000) {
        col = Colors.red;
      }
    }
    if (name == 'Smoke') {
      if (val != null && val > 1000) {
        col = Colors.red;
      }
    }
    return col;
  }

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context)!.settings.arguments as Map;
    final routeVal = route['val'];
    // print(routeVal);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Last 24 Hours'),
          backgroundColor: activeColor2,
          centerTitle: true,
        ),
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Container(
              // width: 500,
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    newData.isNotEmpty
                        ? Text(
                            newData[0][routeVal]['name'].toString(),
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        : const Text('No name'),
                    const SizedBox(
                      height: 20,
                    ),
                    Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: const [
                        TableRow(children: [
                          Text(
                            'Time',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            'Average',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Max',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Min',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ])
                      ],
                    ),
                    Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.bottom,
                        children: List.generate(
                            newData.length,
                            (index) => TableRow(children: [
                                  // Text(
                                  //   (index + 1).toString(),
                                  //   style: const TextStyle(
                                  //       fontSize: 20, color: Colors.white),
                                  // ),

                                  Text(
                                    newData[index][4]['datetime'].toString(),
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 14.0),
                                    child: Text(
                                      newData[index][routeVal]['avg'] == null
                                          ? '--'
                                          : newData[index][routeVal]['avg']
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: showColor(
                                              newData[index][routeVal]['name'],
                                              newData[index][routeVal]['avg'])),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          newData[index][routeVal]
                                                  ['max_time'] ??
                                              '',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          newData[index][routeVal]
                                                      ['max_value'] ==
                                                  null
                                              ? '--'
                                              : newData[index][routeVal]
                                                      ['max_value']
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: showColor(
                                                  newData[index][routeVal]
                                                      ['name'],
                                                  newData[index][routeVal]
                                                      ['max_value'])),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        newData[index][routeVal]['min_time'] ??
                                            '',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                      Text(
                                        newData[index][routeVal]['min_value'] ==
                                                null
                                            ? '--'
                                            : newData[index][routeVal]
                                                    ['min_value']
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: showColor(
                                                newData[index][routeVal]
                                                    ['name'],
                                                newData[index][routeVal]
                                                    ['min_value'])),
                                      ),
                                    ],
                                  ),
                                ]))),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 60),
                      child: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 60),
                                height: 20,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.greenAccent),
                              ),
                            ),
                            const Text('NORMAL',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 60),
                                height: 20,
                                decoration: const BoxDecoration(
                                    // borderRadius: BorderRadius.circular(200.0),
                                    shape: BoxShape.circle,
                                    color: Colors.red),
                              ),
                            ),
                            const Text('ALERT',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ])),
        ));
  }
}
