import 'package:air_monitor/API.dart';
import 'package:air_monitor/widgets/Storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config.dart';

import 'controller/HomeController.dart';

class Alerts extends StatefulWidget {
  const Alerts({super.key});

  @override
  State<Alerts> createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  var controller = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    getData();
    controller.decTime();
    super.initState();
  }

  var newData = List.empty(growable: true);

  // var routeVal = 0;

  getData() async {
    var ndata = getlocData('data');
    var params = {'mac_add': ndata['mac_add']};
    var res = await getWithParams('alert', params);
    var data = res.data;

    setState(() {
      newData = data;
    });

    print('val is $ndata');
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

    return Scaffold(
        appBar: AppBar(
          title: const Text('Alerts'),
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
                            newData[0][routeVal]['name'],
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
                                    newData[index][4]['datetime'],
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 28.0),
                                    child: Text(
                                      newData[index][routeVal]['avg'] == null
                                          ? '--'
                                          : newData[index][routeVal]['avg']
                                              .toString(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.redAccent),
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
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.redAccent),
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
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.redAccent),
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
                                    fontSize: 20, color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ])),
        ));
  }
}
