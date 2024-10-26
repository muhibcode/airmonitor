import 'dart:convert';
import 'package:air_monitor/API.dart';
import 'package:air_monitor/widgets/Storage.dart';
// import 'package:air_monitor/widgets/Storage.dart';
import 'package:air_monitor/widgets/Utils/TextFieldSubmit.dart';
import 'package:crypto/crypto.dart';
import 'package:air_monitor/config.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
// import 'package:http/http.dart' as http;
// import 'package:localstorage/localstorage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var data = {};
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  // Map<String, String> headers = {"Content-type": "application/json"};
  final LocalStorage storage = LocalStorage('AM.json');
  var msg = {};

  final _formKey = GlobalKey<FormState>();

  bool _submitted = false;
  bool visibility = false;

  onSubmit(ctx) async {
    data.addAll({'email': emailCtrl.text, 'password': passwordCtrl.text});
    var res = await postData('login', data);
    var endres = res.data;
    print(endres);
    if (endres['message'] == 'success') {
      var strRes = endres['data']['email'] + endres['data']['user_id'];
      var strResInBytes = utf8.encode(strRes);
      var value = sha256.convert(strResInBytes);
      await setlocData('auth', value.toString());
      await setlocData('data', {'email': endres['data']['email']});

      Navigator.pushReplacementNamed(ctx, 'Menu', arguments: 'login');
    } else {
      if (endres['message'] == 'invalid user') {
        await setlocData('data', {'email': endres['data']['email']});

        return Navigator.pushReplacementNamed(ctx, 'Error',
            arguments: {'val': 'otp'});
      }
      if (endres['message'] == 'invalid email') {
        return Navigator.pushNamed(ctx, 'Error', arguments: {'val': 'cotp'});
      }
      Navigator.pushNamed(ctx, 'Error', arguments: {'val': 'otpp'});
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
        title: const Text('LOGIN'),
        centerTitle: true,
        backgroundColor: activeColor2,
      ),
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          // height: 400,
          // width: 400,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldSubmit(
                    label: 'Email',
                    controller: emailCtrl,
                    submitted: _submitted,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFieldSubmit(
                    label: 'Password',
                    controller: passwordCtrl,
                    submitted: _submitted,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton.icon(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, 'Email');
                      },
                      icon: const Icon(Icons.lock),
                      label: const Text(
                        'Forgot Password?',
                        style: TextStyle(),
                      )),
                  const Center(
                      child: Text(
                    'If not register Go to SignUp first',
                    style: TextStyle(color: Colors.white),
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: TextButton(
                        onPressed: (() =>
                            Navigator.pushReplacementNamed(context, 'SignUp')),
                        child: const Text(
                          'SIGNUP',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
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
                            'Login',
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
