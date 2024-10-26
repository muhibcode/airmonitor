import 'package:air_monitor/API.dart';
import 'package:air_monitor/widgets/Utils/PasswordField.dart';
import 'package:air_monitor/widgets/Utils/TextFieldSubmit.dart';
import 'package:air_monitor/config.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final fnameCtrl = TextEditingController();
  final lnameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final macAddCtrl = TextEditingController();
  final ipAddCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final genderCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final conPasswordCtrl = TextEditingController();

  String buttonText = 'Sign Up';

  var data = {};

  bool _submitted = false;
  bool visibility = false;

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

  onSubmit(ctx) async {
    setState(() {
      buttonText = 'loading...';
    });
    data.addAll({
      'fname': fnameCtrl.text,
      'lname': lnameCtrl.text,
      'phoneNum': phoneCtrl.text,
      'address': addressCtrl.text,
      'city': cityCtrl.text,
      'ipAdd': ipAddCtrl.text,
      'gender': genderCtrl.text,
      'macAdd': macAddCtrl.text,
      'email': emailCtrl.text,
      'password': passwordCtrl.text
    });
    var res = await postData('register', data);
    var endres = res.data;

    print(endres);
    if (endres['message'] == 'success') {
      Navigator.pushReplacementNamed(ctx, 'Otp',
          arguments: {'val': 'signup', 'email': endres['data']['email']});
    } else {
      if (endres['message'] == 'invalid esp') {
        Navigator.pushReplacementNamed(ctx, 'Error',
            arguments: {'val': 'signup-esp'});
      }
      if (endres['message'] == 'invalid esp') {
        Navigator.pushReplacementNamed(ctx, 'Error',
            arguments: {'val': 'signup-user'});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIGNUP'),
        centerTitle: true,
        backgroundColor: activeColor2,
      ),
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          // height: MediaQuery.of(context).size.height,
          // width: 400,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldSubmit(
                      controller: fnameCtrl,
                      submitted: _submitted,
                      label: 'First Name'),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldSubmit(
                    label: 'Last Name',
                    controller: lnameCtrl,
                    submitted: _submitted,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldSubmit(
                    label: 'Email',
                    controller: emailCtrl,
                    submitted: _submitted,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldSubmit(
                    label: 'Phone No',
                    controller: phoneCtrl,
                    submitted: _submitted,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldSubmit(
                    label: 'Gender',
                    controller: genderCtrl,
                    submitted: _submitted,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldSubmit(
                    label: 'City',
                    controller: cityCtrl,
                    submitted: _submitted,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldSubmit(
                    label: 'Address',
                    controller: addressCtrl,
                    submitted: _submitted,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldSubmit(
                    label: 'Mac Add',
                    controller: macAddCtrl,
                    submitted: _submitted,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldSubmit(
                    label: 'IP Add',
                    controller: ipAddCtrl,
                    submitted: _submitted,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  PasswordField(
                      passLabel: 'New Password',
                      conPassLabel: 'Confirm Password',
                      passCtrl: passwordCtrl,
                      conPassCtrl: conPasswordCtrl,
                      submitted: _submitted),
                  const SizedBox(
                    height: 5,
                  ),
                  const Center(
                      child: Text(
                    'If already registered Go to Login',
                    style: TextStyle(color: Colors.white),
                  )),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: TextButton(
                        onPressed: (() =>
                            Navigator.pushReplacementNamed(context, 'Login')),
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: SizedBox(
                        width: 110,
                        child: ElevatedButton(
                          onPressed: () => _submit(context),
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.red)),
                          child: Text(
                            buttonText,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
