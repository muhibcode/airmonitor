import 'package:air_monitor/API.dart';
import 'package:air_monitor/widgets/Storage.dart';
import 'package:air_monitor/widgets/controller/HomeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config.dart';

class LastHour extends StatefulWidget {
  const LastHour({super.key});

  @override
  State<LastHour> createState() => _LastHourState();
}

class _LastHourState extends State<LastHour> {
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
    var res = await getWithParams('last_hour', params);
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Last One Hour'),
          backgroundColor: activeColor2,
          centerTitle: true,
        ),
        backgroundColor: primaryColor,
        body: Container(
            // width: 500,
            padding: const EdgeInsets.only(left: 12),
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: const [
                      TableRow(children: [
                        Text(
                          '#',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Text(
                          'Name',
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
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            'Min',
                            style: TextStyle(fontSize: 20, color: Colors.white),
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
                          (index) => TableRow(
                                children: [
                                  Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  newData.isNotEmpty
                                      ? Text(
                                          newData[index]['name'].toString(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        )
                                      : const Text('No Name'),
                                  newData[index]['avg'] != null
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            newData[index]['avg'].toString(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: showColor(
                                                    newData[index]['name'],
                                                    newData[index]['avg'])),
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Text(
                                            '--',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: showColor(
                                                    newData[index]['name'],
                                                    newData[index]['avg'])),
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          newData[index]['max_time'] ?? '',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                        newData[index]['max_value'] != null
                                            ? Text(
                                                newData[index]['max_value']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: showColor(
                                                        newData[index]['name'],
                                                        newData[index]
                                                            ['max_value'])),
                                              )
                                            : Text(
                                                '--',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: showColor(
                                                        newData[index]['name'],
                                                        newData[index]
                                                            ['max_value'])),
                                              )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        newData[index]['min_time'] ?? '',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                      newData[index]['min_value'] != null
                                          ? Text(
                                              newData[index]['min_value']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: showColor(
                                                      newData[index]['name'],
                                                      newData[index]
                                                          ['min_value'])),
                                            )
                                          : Text(
                                              '--',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: showColor(
                                                      newData[index]['name'],
                                                      newData[index]
                                                          ['min_value'])),
                                            )
                                    ],
                                  ),
                                ],
                              ))),
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
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
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
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white))
                        ],
                      ),
                    ),
                  ),
                ])));
  }
}
