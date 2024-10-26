import 'package:air_monitor/API.dart';
import 'package:air_monitor/widgets/Utils/TextFieldSubmit.dart';
import 'package:flutter/material.dart';

class Email extends StatefulWidget {
  const Email({super.key});

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  bool submitted = false;
  final emailCtrl = TextEditingController();
  String buttonText = 'Submit';
  final _formkey = GlobalKey<FormState>();
  var data = {};

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
    data.addAll({'email': emailCtrl.text});
    var res = await postData('forget_pass', data);
    var endres = res.data;
    print(endres);
    if (endres['message'] == 'success') {
      // storage.setItem('email', endres['data']['email'].toString());
      Navigator.pushReplacementNamed(ctx, 'Password');
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formkey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Text(
                'Enter Valid Registerd Email to get OTP.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFieldSubmit(
                submitted: submitted,
                label: 'Email',
                controller: emailCtrl,
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                    width: 110,
                    child: ElevatedButton(
                      onPressed: () {
                        _submit(context);
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red)),
                      child: Text(
                        buttonText,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
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
