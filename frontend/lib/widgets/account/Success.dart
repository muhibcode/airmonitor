import 'package:air_monitor/config.dart';
import 'package:flutter/material.dart';

class Success extends StatelessWidget {
  const Success({super.key});

  Widget showMsg(ctx, val) {
    if (val == 'signup') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Congratulations You have registered successfully!!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 5),
          const Text(
            'Login Now to Enter.',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 100,
            child: ElevatedButton(
              // duration: Duration(seconds: 1),
              onPressed: () {
                // submit(context);
                Navigator.pushReplacementNamed(ctx, 'Login');
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.green.shade300)),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ),
        ],
      );
    }
    if (val == 'install') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Congratulations device have been installed successfully!!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 5),
          const Text(
            'SignUp Now to Register.',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 100,
            child: ElevatedButton(
              // duration: Duration(seconds: 1),
              onPressed: () {
                // submit(context);
                Navigator.pushReplacementNamed(ctx, 'SignUp');
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.green.shade300)),
              child: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ],
      );
    }
    if (val == 'otp') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Congratulations your Email has verified successfully!!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 100,
            child: ElevatedButton(
              // duration: Duration(seconds: 1),
              onPressed: () {
                // submit(context);
                Navigator.pushReplacementNamed(ctx, 'Login');
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.green.shade300)),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ],
      );
    }
    if (val == 'changePass') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your Password has been updated successfully!!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 100,
            child: ElevatedButton(
              // duration: Duration(seconds: 1),
              onPressed: () {
                // submit(context);
                Navigator.pushReplacementNamed(ctx, 'Login');
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.green.shade300)),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Details have been updated.',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 100,
            child: ElevatedButton(
              // duration: Duration(seconds: 1),
              onPressed: () {
                // submit(context);
                Navigator.pushReplacementNamed(ctx, 'Home');
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.green.shade300)),
              child: const Text(
                'Home',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        padding: const EdgeInsets.only(left: 10),
        child: Center(
          child: showMsg(context, data),
        ),
      ),
    );
  }
}
