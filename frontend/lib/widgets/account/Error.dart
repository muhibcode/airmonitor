import 'package:air_monitor/config.dart';
import 'package:flutter/material.dart';

class ACError extends StatelessWidget {
  // final route;

  const ACError({super.key});

  Widget showError(ctx, val) {
    if (val['val'] == 'signup-user') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Email You entered is already registered!!.',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 5),
          const Text(
            'Please give some original Email.',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              // duration: Duration(seconds: 1),
              onPressed: () {
                // submit(context);
                Navigator.pop(ctx);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(activeColor2),
                // shape: MaterialStatePropertyAll(BorderRadius.circular(20))
              ),
              child: const Center(
                  child: Text(
                'TRY AGAIN',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
            ),
          ),
        ],
      );
    }
    if (val['val'] == 'signup-esp') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'ESP not found!!.',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 5),
          const Text(
            'Please install ESP first.',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              // duration: Duration(seconds: 1),
              onPressed: () {
                // submit(context);
                Navigator.pop(ctx);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(activeColor2),
                // shape: MaterialStatePropertyAll(BorderRadius.circular(20))
              ),
              child: const Center(
                  child: Text(
                'TRY AGAIN',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
            ),
          ),
        ],
      );
    }
    if (val['val'] == 'install') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Device on this mac address is already installed!!.',
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          const Text(
            'Please Try with some other mac address.',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              // duration: Duration(seconds: 1),
              onPressed: () {
                // submit(context);
                Navigator.pop(ctx, 'SignUp');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(activeColor2),
                // shape: MaterialStatePropertyAll(BorderRadius.circular(20))
              ),
              child: const Center(
                  child: Text(
                'TRY AGAIN',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
            ),
          ),
        ],
      );
    }
    if (val['val'] == 'rsignupotp') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Please enter correct OTP to verify.',
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(activeColor2),
              ),
              child: const Center(
                  child: Text(
                'Try Again',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
            ),
          ),
        ],
      );
    }
    if (val['val'] == 'signupotp') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Please Sign Up again to register.',
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(ctx, 'SignUp');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(activeColor2),
              ),
              child: const Center(
                  child: Text(
                'Try Again',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
            ),
          ),
        ],
      );
    }
    if (val['val'] == 'rloginotp') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Invalid OTP\nPlease Enter valid OTP.',
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(activeColor2),
              ),
              child: const Center(
                  child: Text(
                'Try Again',
                style: TextStyle(fontSize: 20, color: Colors.black),
              )),
            ),
          ),
        ],
      );
    }
    if (val['val'] == 'loginotp') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'You have not provided authentic Email.\nPlease provide authentic Email to register.',
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(ctx, 'SignUp');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(activeColor2),
              ),
              child: const Center(
                  child: Text(
                'Try Again',
                style: TextStyle(fontSize: 20, color: Colors.black),
              )),
            ),
          ),
        ],
      );
    }
    if (val['val'] == 'otp') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'You are not yet registerd. \nplease provide OTP we send to your email id.',
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(ctx, 'Otp',
                    arguments: {'val': 'login', 'email': val['email']});
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(activeColor2),
              ),
              child: const Center(
                  child: Text(
                'Enter OTP',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
            ),
          ),
        ],
      );
    }
    if (val['val'] == 'cotp') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Incorrect Email!!.',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 5),
          const Text(
            'Please Try Again',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              // duration: Duration(seconds: 1),
              onPressed: () {
                // submit(context);
                Navigator.pop(ctx);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(activeColor2),
                // shape: MaterialStatePropertyAll(BorderRadius.circular(20))
              ),
              child: const Center(
                  child: Text(
                'TRY AGAIN',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
            ),
          ),
        ],
      );
    }
    if (val['val'] == 'oldpassword') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Incorrect Old Password.',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 5),
          const Text(
            'Please Try Again',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              // duration: Duration(seconds: 1),
              onPressed: () {
                // submit(context);
                Navigator.pop(ctx);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(activeColor2),
                // shape: MaterialStatePropertyAll(BorderRadius.circular(20))
              ),
              child: const Center(
                  child: Text(
                'TRY AGAIN',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Incorrect Password!!.',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 5),
          const Text(
            'Please Try Again',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              // duration: Duration(seconds: 1),
              onPressed: () {
                // submit(context);
                Navigator.pop(ctx);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(activeColor2),
                // shape: MaterialStatePropertyAll(BorderRadius.circular(20))
              ),
              child: const Center(
                  child: Text(
                'TRY AGAIN',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        padding: const EdgeInsets.only(left: 10),
        child: Center(
          child: showError(context, data),
        ),
      ),
    );
  }
}
