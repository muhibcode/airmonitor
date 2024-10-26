import 'package:air_monitor/API.dart';
import 'package:air_monitor/widgets/Storage.dart';
import 'package:air_monitor/widgets/Utils/PasswordField.dart';
import 'package:air_monitor/widgets/Utils/TextFieldSubmit.dart';
import 'package:flutter/material.dart';

class Password extends StatefulWidget {
  const Password({super.key});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  bool submitted = false;
  final newPassCtrl = TextEditingController();
  final conPassCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final otpCtrl = TextEditingController();

  String buttonText = 'Submit';
  var data = {};
  var _formkey = GlobalKey<FormState>();

  void _submit(ctx) {
    setState(() {
      submitted = true;
    });
    // validate all the form fields
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      // on success, notify the parent widget
      onSubmit(ctx);
    }
  }

  onSubmit(ctx) async {
    setState(() {
      buttonText = 'loading...';
    });
    data.addAll({
      'email': emailCtrl.text,
      'otp': otpCtrl.text,
      'password': newPassCtrl.text
    });
    var res = await postData('verify_old', data);
    var endres = res.data;
    print(endres);
    if (endres['message'] == 'success') {
      storage.deleteItem('auth');
      Navigator.pushReplacementNamed(ctx, 'Success', arguments: 'changePass');
    } else {
      if (endres['message'] == 'invalid user') {
        return Navigator.pushReplacementNamed(ctx, 'Error',
            arguments: {'val': 'otp'});
      }

      Navigator.pushReplacementNamed(ctx, 'Error', arguments: 'otpp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                TextFieldSubmit(
                  label: 'OTP',
                  controller: otpCtrl,
                  submitted: submitted,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldSubmit(
                  label: 'Email',
                  controller: emailCtrl,
                  submitted: submitted,
                ),
                const SizedBox(
                  height: 10,
                ),
                PasswordField(
                    passLabel: 'New Password',
                    conPassLabel: 'Confirm New Password',
                    passCtrl: newPassCtrl,
                    conPassCtrl: conPassCtrl,
                    submitted: submitted),
                const SizedBox(height: 20),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
