import 'package:flutter/material.dart';

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
            style: ButtonStyle(
                fixedSize:
                    MaterialStateProperty.all<Size>(const Size.fromHeight(10)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
            onPressed: () {
              Navigator.pushNamed(context, 'InstallESP');
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            label: const Text(
              'Install ESP',
              style: TextStyle(color: Colors.black, fontSize: 20),
            )),
        ElevatedButton.icon(
            style: ButtonStyle(
                fixedSize:
                    MaterialStateProperty.all<Size>(const Size.fromHeight(10)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'SignUp');
            },
            icon: const Icon(
              Icons.app_registration,
              color: Colors.black,
            ),
            label: const Text(
              'Sign Up',
              style: TextStyle(color: Colors.black, fontSize: 20),
            )),
        ElevatedButton.icon(
            style: ButtonStyle(
                fixedSize:
                    MaterialStateProperty.all<Size>(const Size.fromHeight(10)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'Login');
            },
            icon: const Icon(
              Icons.login,
              color: Colors.black,
            ),
            label: const Text(
              'Login',
              style: TextStyle(color: Colors.black, fontSize: 20),
            )),
      ],
    );
  }
}
