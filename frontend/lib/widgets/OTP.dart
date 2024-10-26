import 'package:air_monitor/API.dart';
import 'package:air_monitor/widgets/Storage.dart';
import 'package:air_monitor/widgets/Utils/TextFieldSubmit.dart';
import 'package:flutter/material.dart';

class OTP extends StatefulWidget {
  const OTP({super.key});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  bool _submitted = false;
  final otpCtrl = TextEditingController();
  String routeVal = '';
  String email = '';
  int counter = 1;
  bool check = false;
  var formkey = GlobalKey<FormState>();
  var data = {};

  @override
  void didChangeDependencies() {
    setRoute();
    super.didChangeDependencies();
  }

  void _submit(ctx) {
    setState(() {
      _submitted = true;
    });
    // validate all the form fields
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();

      // on success, notify the parent widget
      onSubmit(ctx);
    }
  }

  resendEmail() async {
    var ndata = getlocData('data');
    var params = {'email': ndata['email']};
    await getWithParams('resend_email', params);

    setState(() {
      check = true;
    });
  }

  // getUser() async {}

  setRoute() async {
    var route = ModalRoute.of(context)!.settings.arguments as Map;

    setState(() {
      routeVal = route['val'];
      email = route['email'];
    });
  }

  onSubmit(ctx) async {
    data.addAll({'otp': otpCtrl.text, 'email': email, 'attempt': counter});
    var res = await postData('verify_user', data);
    var endres = res.data;
    print(endres);
    if (endres['message'] == 'success') {
      Navigator.pushReplacementNamed(ctx, 'Success', arguments: 'otp');
    } else {
      if (endres['message'] == 'invalid otp') {
        if (routeVal == 'login') {
          if (counter == 3) {
            Navigator.pushReplacementNamed(ctx, 'Error',
                arguments: {'val': 'loginotp'});
          } else {
            Navigator.pushNamed(ctx, 'Error', arguments: {'val': 'rloginotp'});
          }
          setState(() {
            counter += 1;
          });
        } else {
          if (counter == 3) {
            Navigator.pushReplacementNamed(ctx, 'Error',
                arguments: {'val': 'signupotp'});
          } else {
            Navigator.pushNamed(ctx, 'Error', arguments: {'val': 'rsignupotp'});
          }
          setState(() {
            counter += 1;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFieldSubmit(
                label: 'OTP',
                controller: otpCtrl,
                submitted: _submitted,
              ),
              const SizedBox(
                height: 20,
              ),
              Text('Attempts remaing ${3 - counter}'),
              const SizedBox(
                height: 5,
              ),
              routeVal == 'login'
                  ? Column(children: [
                      const Text(
                        'If you dont have OTP \nPlease press the below button to resend email.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () => resendEmail(),
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.red)),
                              child: const Text(
                                'Resend Email',
                                style: TextStyle(color: Colors.black),
                              ),
                            )),
                      ),
                      const SizedBox(height: 10),
                      check
                          ? const Text(
                              'Check Your Mail box',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox(
                              height: 20,
                            ),
                      Center(
                        child: SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () => _submit(context),
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.red)),
                              child: const Text(
                                'Submit',
                                style: TextStyle(color: Colors.black),
                              ),
                            )),
                      ),
                    ])
                  : Center(
                      child: SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () => _submit(context),
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.red)),
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.black),
                            ),
                          )),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
