import 'package:air_monitor/API.dart';
import 'package:air_monitor/config.dart';
import 'package:air_monitor/widgets/Storage.dart';
import 'package:air_monitor/widgets/Utils/TextFieldSubmit.dart';
import 'package:flutter/material.dart';

class InstallESP extends StatefulWidget {
  const InstallESP({super.key});

  @override
  State<InstallESP> createState() => _InstallESPState();
}

class _InstallESPState extends State<InstallESP> {
  final macAddCtrl = TextEditingController();
  final ipAddCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  var moduleType = '';
  var data = {};

  final _formKey = GlobalKey<FormState>();

  final List _sensors = [];
  List inds = [];
  bool _submitted = false;

  void _submit(ctx) {
    setState(() {
      _submitted = true;
    });
    // validate all the form fields
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // on success, notify the parent widget
      onSubmit(ctx);
    }
  }

  var gases = ['Detects', 'CO', 'CH4', 'LPG', 'Smoke', 'CO2', 'NO2'];
  var sensors = ['Name', 'mq2', 'mq4', 'mq5', 'mq9'];
  var esps = ['Select Type', 'Arduino', 'Arduino Cam', 'ESP32'];

  removeButton(rIndex) {
    return ElevatedButton.icon(
        icon: const Icon(
          Icons.delete,
          color: Colors.black,
        ),
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.red)),
        onPressed: () {
          setState(() {
            _sensors.removeAt(rIndex);
          });
        },
        label: const Text(
          'Remove',
          style: TextStyle(color: Colors.black),
        ));
  }

  addSensor() {
    setState(() {
      _sensors.add({});
    });
  }

  sensorDropDown(val, ind) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
              // labelStyle: textStyle,
              errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          // isEmpty: _currentSelectedValue == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _sensors[ind][val] ?? sensors[0],
              isDense: true,
              onChanged: (value) {
                if (value != 'Name') {
                  setState(() {
                    _sensors[ind][val] = value;
                  });
                }
              },
              items: sensors.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  gasDropDown(val, ind) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
              // labelStyle: textStyle,
              errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
              hintText: 'Please select expense',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          // isEmpty: _currentSelectedValue == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _sensors[ind][val] ?? gases[0],
              isDense: true,
              onChanged: (value) {
                if (value != 'Detects') {
                  setState(() {
                    _sensors[ind][val] = value;
                  });
                }
              },
              items: gases.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  typeDropDown() {
    return FormField<String>(
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return 'not empty';
      //   }
      // },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(

              // labelStyle: textStyle,
              errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          // isEmpty: _currentSelectedValue == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: moduleType.isEmpty ? esps[0] : moduleType,
              isDense: true,
              onChanged: (value) {
                if (value != 'Module Type') {
                  setState(() {
                    moduleType = value!;
                  });
                }
              },
              items: esps.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  onSubmit(ctx) async {
    var flaskUrl = getlocData('flaskUrl');
    // var flaskUrl = storage.getItem('flaskUrl');

    var url = Uri.parse('http://$flaskUrl/install');

    data.addAll({
      'name': nameCtrl.text,
      'moduleType': moduleType,
      'macAdd': macAddCtrl.text,
      'ipAdd': ipAddCtrl.text,
      'sensors': _sensors
    });

    var res = await postData(url, data);
    var endres = res.data;

    if (endres['message'] == 'success') {
      Navigator.pushReplacementNamed(ctx, 'Success', arguments: 'install');
    } else {
      if (endres['message'] == 'already exist') {
        Navigator.pushNamed(ctx, 'Error', arguments: 'install');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Install ESP'),
        centerTitle: true,
        backgroundColor: activeColor2,
      ),
      backgroundColor: primaryColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                typeDropDown(),
                const SizedBox(
                  height: 15,
                ),
                TextFieldSubmit(
                  label: 'Name',
                  controller: nameCtrl,
                  submitted: _submitted,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFieldSubmit(
                  label: 'Mac Address',
                  controller: macAddCtrl,
                  submitted: _submitted,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFieldSubmit(
                  label: 'IP Address',
                  controller: ipAddCtrl,
                  submitted: _submitted,
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                    children: List.generate(_sensors.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sensor ${index + 1}'),
                        const SizedBox(
                          height: 10,
                        ),
                        sensorDropDown('name', index),
                        const SizedBox(
                          height: 10,
                        ),
                        gasDropDown('detects', index),
                        const SizedBox(
                          height: 5,
                        ),
                        Center(child: removeButton(index))
                      ],
                    ),
                  );
                })),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.green.shade300)),
                    onPressed: () {
                      addSensor();
                    },
                    child: const Text(
                      'Add Sensor',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.green.shade400)),
                    onPressed: () {
                      _submit(context);
                    },
                    child: const Text(
                      'Install',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
