import 'package:air_monitor/API.dart';
import 'package:air_monitor/widgets/Storage.dart';
import 'package:air_monitor/widgets/Utils/TextFieldSubmit.dart';
import 'package:air_monitor/widgets/controller/HomeController.dart';
import 'package:flutter/material.dart';
import 'package:air_monitor/config.dart';
import 'package:get/get.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  bool submitted = false;
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

  var data = {};
  var controller = Get.put(HomeController());

  @override
  void initState() {
    controller.decTime();
    getUser();

    super.initState();
  }

  getUser() async {
    var ndata = getlocData('data');

    var params = {'email': ndata['email']};
    var res = await getWithParams('get_user', params);
    var fres = res.data;
    setState(() {
      emailCtrl.text = fres['email'];
      fnameCtrl.text = fres['fname'];
      lnameCtrl.text = fres['lname'];
      cityCtrl.text = fres['city'];
      addressCtrl.text = fres['address'];
      ipAddCtrl.text = fres['ip_add'];
      macAddCtrl.text = fres['mac_add'];
      genderCtrl.text = fres['gender'];
      phoneCtrl.text = fres['phone_num'];
    });
    print(phoneCtrl.text);
  }

  onSubmit(ctx) async {
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
    });

    var res = await postData('update_user', data);
    var endres = res.data;
    if (endres['message'] == 'success') {
      Navigator.pushReplacementNamed(
        ctx,
        'Success',
      );
    }
  }

  void _submit(ctx) {
    setState(() {
      submitted = true;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
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
                      submitted: submitted,
                      label: 'First Name'),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldSubmit(
                      controller: lnameCtrl,
                      submitted: submitted,
                      label: 'Last Name'),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldSubmit(
                      rOnly: true,
                      controller: emailCtrl,
                      submitted: submitted,
                      label: 'Email'),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldSubmit(
                      controller: phoneCtrl,
                      submitted: submitted,
                      label: 'Phone No'),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldSubmit(
                      controller: genderCtrl,
                      submitted: submitted,
                      label: 'Gender'),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldSubmit(
                      controller: macAddCtrl,
                      submitted: submitted,
                      label: 'Mac Add'),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldSubmit(
                      controller: ipAddCtrl,
                      submitted: submitted,
                      label: 'IP Address'),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldSubmit(
                      controller: cityCtrl,
                      submitted: submitted,
                      label: 'City'),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldSubmit(
                      controller: addressCtrl,
                      submitted: submitted,
                      label: 'Address'),
                  const SizedBox(
                    height: 10,
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
                          child: const Text(
                            'Update',
                            style: TextStyle(color: Colors.black, fontSize: 18),
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
