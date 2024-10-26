import 'package:air_monitor/API.dart';
import 'package:air_monitor/config.dart';
import 'package:air_monitor/widgets/Storage.dart';
import 'package:air_monitor/widgets/controller/HomeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  var controller = Get.put(HomeController());

  String dropdownValue = '';
  String sensdropdownValue = '';

  var mac_add = '';
  String esp_id = '';

  List<String> modlist = <String>[
    'Select Item',
    'Arduino',
    'Arduino Cam',
    'ESP32'
  ];

  List<String> sensor = <String>['Sensor'];
  var pin = [];

  @override
  void initState() {
    controller.decTime();
    setRoute();
    super.initState();
  }

  setRoute() async {
    var ndata = getlocData('data');
    var params = {'email': ndata['email']};
    // print('route is $params');

    var res = await getWithParams('get_esp', params);
    var endres = res.data;
    setState(() {
      mac_add = endres['esp']['mac_add'];
      esp_id = endres['esp']['esp_id'];
    });
    var sdata = getlocData('data') as Map<String, dynamic>;
    sdata.addAll({
      'user_id': endres['user']['user_id'],
      'mac_add': endres['esp']['mac_add'],
      'esp_id': endres['esp']['esp_id']
    });
    await setlocData('data', sdata);
  }

  getSensor(val, type) async {
    var params = {'mac_add': val, 'type': type, 'esp_id': esp_id};
    var res = await getWithParams('get_sensors', params);
    var endres = res.data;
    sensor = ['Sensors'];
    if (endres['response'] == 'No Sensor') {
      setState(() {
        sensor = [];
        sensor.add('No Sensor');
      });
    } else {
      for (var e in endres['response']) {
        var name = e['name'] + ' ' + '(${e['detects']})';
        setState(() {
          sensor.add(name);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var route = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: dropdownValue.isEmpty ? modlist[0] : dropdownValue,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
            elevation: 16,
            dropdownColor: Colors.red,

            // hint: Text('Select Item'),
            style: const TextStyle(color: Colors.white, fontSize: 20),
            underline: Container(
              height: 2,
              color: Colors.white,
            ),
            onChanged: (String? value) {
              if (value != 'Select Item') {
                print('runs');
                setState(() {
                  dropdownValue = value!;
                  getSensor(mac_add, value);
                });
              } else {
                setState(() {
                  dropdownValue = value!;
                });
              }
            },
            items: modlist.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 100,
          ),
          Center(
            child: DropdownButton<String>(
              value:
                  sensdropdownValue.isNotEmpty ? sensdropdownValue : sensor[0],
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              elevation: 16,
              dropdownColor: Colors.red,

              // hint: Text('Select Item'),
              style: const TextStyle(color: Colors.white, fontSize: 20),
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              onChanged: (String? value) {},

              items: List.generate(
                  sensor.length,
                  (index) => DropdownMenuItem(
                      value: sensor[index], child: Text(sensor[index]))),
            ),
          ),
          const SizedBox(height: 80),
          SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  if (sensor[0] == 'No Sensor' || sensor[0] == 'Sensor') {
                    null;
                  } else {
                    if (route == 'login') {
                      Navigator.pushReplacementNamed(context, 'Home');
                    } else {
                      Navigator.pop(context);
                    }
                  }
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red)),
                child: const Text(
                  'Go To App',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              )),
        ],
      ),
    );
  }
}
