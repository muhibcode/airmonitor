import 'dart:async';

import 'package:air_monitor/API.dart';
import 'package:air_monitor/widgets/EnvCon.dart';
import 'package:air_monitor/widgets/Storage.dart';
import 'package:air_monitor/widgets/Utils/ExpansionDrawer.dart';
import 'package:air_monitor/widgets/Utils/SleekSlide.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:air_monitor/config.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'controller/HomeController.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var controller = Get.put(HomeController());

  double co = 0.0;
  double ch4 = 0.0;
  double lpg = 0.0;
  double smoke = 0.0;

  double mco = 0.0;
  double mch4 = 0.0;
  double mlpg = 0.0;
  double msmoke = 0.0;
  String email = '';
  late Timer _timer;
  var counter = 3;

  @override
  void initState() {
    super.initState();

    socket.connect();

    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'testing');
    });

    getData();
    showInitData();
    showData();
    controller.incTime();
    socket.onDisconnect((_) => print('disconnect'));
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  dispose() {
    _timer.cancel();
    super.dispose();
  }

  showInitData() async {
    var d = getlocData('data');

    var params = {'mac_add': d['mac_add']};
    var res = await getWithParams('each_min', params);

    var fres = res.data;
    // print(fres);

    setState(() {
      mco = fres['data']['CO'] != null
          ? double.parse(fres['data']['CO'].toString())
          : 0.0;
      mch4 = fres['data']['CH4'] != null
          ? double.parse(fres['data']['CH4'].toString())
          : 0.0;
      mlpg = fres['data']['LPG'] != null
          ? double.parse(fres['data']['LPG'].toString())
          : 0.0;
      msmoke = fres['data']['Smoke'] != null
          ? double.parse(fres['data']['Smoke'].toString())
          : 0.0;
    });
  }

  showData() async {
    var d = getlocData('data');
    var params = {'mac_add': d['mac_add']};

    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      print(timer.tick);

      var res = await getWithParams('each_min', params);

      var fres = res.data;
      // print(fres);

      setState(() {
        mco = fres['data']['CO'] != null
            ? double.parse(fres['data']['CO'].toString())
            : 0.0;
        mch4 = fres['data']['CH4'] != null
            ? double.parse(fres['data']['CH4'].toString())
            : 0.0;
        mlpg = fres['data']['LPG'] != null
            ? double.parse(fres['data']['LPG'].toString())
            : 0.0;
        msmoke = fres['data']['Smoke'] != null
            ? double.parse(fres['data']['Smoke'].toString())
            : 0.0;
      });

      if (controller.timeCount.value == 0) {
        print('cancel timer');
        timer.cancel();
      }
    });
  }

  triggerNotification(val) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: 'basic_channel',
            title: 'Alert Situation',
            body: val));
  }

  getData() {
    var d = getlocData('data');
    print(d);
    socket.on('msg' + d['mac_add'] + d['esp_id'], (data) {
      if (mounted) {
        setState(() {
          if (data['data']['CO'] != null) {
            co = double.parse(data['data']['CO'].toString());
            if (co > 2000) {
              triggerNotification('Carbon monoxide is emitting above normal');
            }
          }
          if (data['data']['CH4'] != null) {
            ch4 = double.parse(data['data']['CH4'].toString());
            if (ch4 > 2200) {
              triggerNotification('Natural Gas emission is happening');
            }
          }
          if (data['data']['LPG'] != null) {
            lpg = double.parse(data['data']['LPG'].toString());
            if (lpg > 2300) {
              triggerNotification('Cylinder emission is happening');
            }
          }
          if (data['data']['Smoke'] != null) {
            smoke = double.parse(data['data']['Smoke'].toString());
            if (smoke > 2500) {
              triggerNotification('Smoke is exceeding above normal');
            }
          }
        });
      }
    });
  }

  getVals(label, args1, args2) {
    var res = Navigator.pushNamed(context, label,
        arguments: {'time': args1, 'val': args2});
    res.then((value) {
      showInitData();
      showData();
      controller.incTime();
      // print(controller.timeCount.value);
    });
  }

  int selected = -1;

  @override
  Widget build(BuildContext context) {
    // setRoute(ctx);
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          title: const Text('Air Monitor'),
          centerTitle: true,
          backgroundColor: activeColor2,
        ),
        drawer: Drawer(
          backgroundColor: Colors.red,
          surfaceTintColor: Colors.black,
          shadowColor: Colors.lightBlue,
          width: 215,
          child: Container(
            padding: const EdgeInsets.only(top: 50),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    label: const Text('Menu',
                        style: TextStyle(
                            fontSize: 19,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    icon: const Icon(
                      Icons.alarm,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      var res = Navigator.pushNamed(context, 'Menu',
                          arguments: {'email': email});
                      res.then((value) {
                        showInitData();
                        showData();
                        controller.incTime();
                      });
                      // Navigator.pop(context);
                    },
                  ),
                  TextButton.icon(
                    label: const Text('User Profile',
                        style: TextStyle(
                            fontSize: 19,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    icon: const Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      var res = Navigator.pushNamed(context, 'User');
                      res.then((value) {
                        showInitData();
                        showData();
                        controller.incTime();
                      });
                    },
                  ),
                  TextButton.icon(
                    label: const Text('Last Hour',
                        style: TextStyle(
                            fontSize: 19,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    icon: const Icon(
                      Icons.alarm,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      var res = Navigator.pushNamed(context, 'LastHr');
                      res.then((value) {
                        showInitData();
                        showData();
                        controller.incTime();
                      });
                    },
                  ),
                  ExpansionDrawer(
                    label: 'Alerts',
                    pIcon: const Icon(
                      Icons.warning,
                      color: Colors.black,
                    ),
                    cIcon: const Icon(
                      Icons.gas_meter,
                      color: Colors.black,
                    ),
                    isExpanded: selected == 0,
                    onExpansion: (val) {
                      if (val) {
                        setState(() {
                          selected = 0;
                        });
                      } else {
                        setState(() {
                          selected = -1;
                        });
                      }
                    },
                    onTap: (ind) {
                      getVals('Alert', '-', ind);
                    },
                  ),
                  ExpansionDrawer(
                    label: '24 Hours',
                    pIcon: const Icon(
                      Icons.alarm,
                      color: Colors.black,
                    ),
                    cIcon: const Icon(
                      Icons.gas_meter,
                      color: Colors.black,
                    ),
                    isExpanded: selected == 1,
                    onExpansion: (val) {
                      if (val) {
                        setState(() {
                          selected = 1;
                        });
                      } else {
                        setState(() {
                          selected = -1;
                        });
                      }
                    },
                    onTap: (ind) {
                      getVals('Last24Hrs', '-', ind);
                    },
                  ),
                  ExpansionDrawer(
                    label: 'One Hr Chart',
                    pIcon: const Icon(
                      Icons.bar_chart,
                      color: Colors.black,
                    ),
                    cIcon: const Icon(
                      Icons.gas_meter,
                      color: Colors.black,
                    ),
                    isExpanded: selected == 2,
                    onExpansion: (val) {
                      if (val) {
                        setState(() {
                          selected = 2;
                        });
                      } else {
                        setState(() {
                          selected = -1;
                        });
                      }
                    },
                    onTap: (ind) {
                      getVals('Chart', 'hour', ind);
                    },
                  ),
                  ExpansionDrawer(
                    label: '24 Hrs Chart',
                    pIcon: const Icon(
                      Icons.bar_chart,
                      color: Colors.black,
                    ),
                    cIcon: const Icon(
                      Icons.gas_meter,
                      color: Colors.black,
                    ),
                    isExpanded: selected == 3,
                    onExpansion: (val) {
                      if (val) {
                        setState(() {
                          selected = 3;
                        });
                      } else {
                        setState(() {
                          selected = -1;
                        });
                      }
                    },
                    onTap: (ind) {
                      getVals('Chart', 'day', ind);
                    },
                  ),
                  TextButton.icon(
                    icon: const Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'ChangePassword');
                    },
                    label: const Text(
                      'Change Password',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // _timer.cancel();
                      storage.clear();
                      Navigator.pushReplacementNamed(context, 'MStart');
                    },
                    label: const Text(
                      'Log Out',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   DateFormat('KK:mm a').format(DateTime.now()),
                  //   style: const TextStyle(color: Colors.white, fontSize: 20),
                  // ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(DateTime.now()),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SleekSlide(
                          label: 'CO',
                          gvalue: mco,
                          tvalue: 450,
                        ),
                        SleekSlide(
                          label: 'CH4',
                          gvalue: mch4,
                          tvalue: 1000,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SleekSlide(
                          label: 'LPG',
                          gvalue: mlpg,
                          tvalue: 800,
                        ),
                        SleekSlide(
                          label: 'Smoke',
                          gvalue: msmoke,
                          tvalue: 1200,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 170),
                      child: Text(
                        'Env. Condition',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CO',
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 6),
                              Text('$co ppm',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 25))
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   width: 2,
                        // ),
                        Expanded(
                          child: Row(
                            children: [
                              EnvCon(
                                title: 'Good',
                                color: co < 300
                                    ? Colors.greenAccent
                                    : Colors.white,
                              ),
                              EnvCon(
                                title: 'Moderate',
                                color: 450 > co && co > 300
                                    ? Colors.orangeAccent
                                    : Colors.white,
                              ),
                              EnvCon(
                                title: 'Poor',
                                color: co > 300 ? activeColor2 : Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CH4 Gas',
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 6),
                              Text('$ch4 ppm',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 25))
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   width: 2,
                        // ),
                        Expanded(
                          child: Row(
                            children: [
                              EnvCon(
                                title: 'Good',
                                color: ch4 < 300
                                    ? Colors.greenAccent
                                    : Colors.white,
                              ),
                              EnvCon(
                                title: 'Moderate',
                                color: 450 > ch4 && ch4 > 300
                                    ? Colors.orangeAccent
                                    : Colors.white,
                              ),
                              EnvCon(
                                title: 'Poor',
                                color: ch4 > 300 ? activeColor2 : Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'LPG',
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 6),
                              Text('$lpg ppm',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 25))
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   width: 2,
                        // ),
                        Expanded(
                          child: Row(
                            children: [
                              EnvCon(
                                title: 'Good',
                                color: lpg < 150
                                    ? Colors.greenAccent
                                    : Colors.white,
                              ),
                              EnvCon(
                                title: 'Moderate',
                                color: 150 < lpg && lpg < 300
                                    ? Colors.orangeAccent
                                    : Colors.white,
                              ),
                              EnvCon(
                                title: 'Poor',
                                color: lpg > 300 ? activeColor2 : Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Smoke',
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 6),
                              Text('$smoke ppm',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 25))
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   width: 2,
                        // ),
                        Expanded(
                          child: Row(
                            children: [
                              EnvCon(
                                title: 'Good',
                                color: smoke < 300
                                    ? Colors.greenAccent
                                    : Colors.white,
                              ),
                              EnvCon(
                                title: 'Moderate',
                                color: 450 > smoke && smoke > 300
                                    ? Colors.orangeAccent
                                    : Colors.white,
                              ),
                              EnvCon(
                                title: 'Poor',
                                color:
                                    smoke > 300 ? activeColor2 : Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ]));
  }
}
