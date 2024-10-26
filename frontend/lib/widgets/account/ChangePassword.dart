import 'package:air_monitor/API.dart';
import 'package:air_monitor/config.dart';
import 'package:air_monitor/widgets/Storage.dart';
import 'package:air_monitor/widgets/Utils/PasswordField.dart';
import 'package:air_monitor/widgets/Utils/TextFieldSubmit.dart';
import 'package:air_monitor/widgets/controller/HomeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var controller = Get.put(HomeController());

  @override
  void initState() {
    controller.decTime();
    super.initState();
  }

  final oldPassCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final conPassCtrl = TextEditingController();

  Map<String, String> headers = {"Content-type": "application/json"};

  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;
  var data = {};

  onSubmit(ctx) async {
    var d = getlocData('data');

    data.addAll({
      'email': d['email'],
      'oldPass': oldPassCtrl.text,
      'newPass': newPassCtrl.text
    });

    var res = await postData('change_pass', data);
    var endres = res.data;
    print(endres);
    if (endres['message'] == 'success') {
      Navigator.pushReplacementNamed(ctx, 'Success',
          arguments: {'val': 'changePass'});
    } else {
      if (endres['message'] == 'invalid password') {
        Navigator.pushReplacementNamed(ctx, 'Error',
            arguments: {'val': 'oldpassword'});
      }

      // Navigator.pushReplacementNamed(ctx, 'Error', arguments: 'otpp');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    // socket.on('hello', (msg) => print(msg));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
        backgroundColor: activeColor2,
      ),
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(
                height: 20,
              ),
              TextFieldSubmit(
                label: 'Old Password',
                controller: oldPassCtrl,
                submitted: _submitted,
              ),
              const SizedBox(
                height: 15,
              ),
              PasswordField(
                  passLabel: 'New Password',
                  conPassLabel: 'Confirm New Password',
                  passCtrl: newPassCtrl,
                  conPassCtrl: conPassCtrl,
                  submitted: _submitted),
              const SizedBox(
                height: 10,
              ),
              TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'Email');
                  },
                  icon: const Icon(Icons.lock),
                  label: const Text('Forgot Password?')),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        _submit(context);
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red)),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    )),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
