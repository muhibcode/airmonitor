import 'package:air_monitor/widgets/Storage.dart';
import 'package:air_monitor/widgets/Utils/TextFieldSubmit.dart';
import 'package:flutter/material.dart';

class MStart extends StatefulWidget {
  const MStart({super.key});

  @override
  State<MStart> createState() => _MStartState();
}

class _MStartState extends State<MStart> {
  // final LocalStorage storage = LocalStorage('AM.json');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var formkey = GlobalKey<FormState>();
  bool submitted = false;
  var urlCtrl = TextEditingController();
  void _submit(ctx) async {
    setState(() {
      submitted = true;
    });
    // validate all the form fields
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      Navigator.pushReplacementNamed(context, 'Start');

      await setlocData('flaskUrl', urlCtrl.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9.0),
              child: TextFieldSubmit(
                  controller: urlCtrl,
                  submitted: submitted,
                  label: 'Flask URL'),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      _submit(context);
                    },
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
