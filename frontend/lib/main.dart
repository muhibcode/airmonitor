import 'package:air_monitor/widgets/Alerts.dart';
import 'package:air_monitor/widgets/Charts/Chart.dart';
import 'package:air_monitor/widgets/Forget/Email.dart';
import 'package:air_monitor/widgets/Forget/Password.dart';
import 'package:air_monitor/widgets/Home.dart';
import 'package:air_monitor/widgets/InstallESP.dart';
import 'package:air_monitor/widgets/MStart.dart';
import 'package:air_monitor/widgets/Menu.dart';
import 'package:air_monitor/widgets/OTP.dart';
import 'package:air_monitor/widgets/Start.dart';
import 'package:air_monitor/widgets/Tabular/LastHour.dart';
import 'package:air_monitor/widgets/Tabular/24hrs.dart';
import 'package:air_monitor/widgets/account/ChangePassword.dart';
import 'package:air_monitor/widgets/account/Error.dart';
import 'package:air_monitor/widgets/account/Login.dart';
import 'package:air_monitor/widgets/account/SignUp.dart';
import 'package:air_monitor/widgets/account/Success.dart';
import 'package:air_monitor/widgets/account/User.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:localstorage/localstorage.dart';

import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'airmon',
        channelDescription: 'airmon')
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final LocalStorage st = LocalStorage('AM.json');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        // home: st.getItem('auth') != null ? const Home() : const MStart(),
        home: FutureBuilder(
            future: st.ready,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return st.getItem('auth') != null
                    ? const Home()
                    : const MStart();
              } else {
                return const Scaffold(
                  body: Center(
                    child: Text(
                      'LOADING...',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
            }),
        routes: {
          'Home': (ctx) => const Home(),
          'Login': (ctx) => const Login(),
          'SignUp': (ctx) => const SignUp(),
          'Error': (ctx) => const ACError(),
          'LastHr': (ctx) => const LastHour(),
          'Chart': (ctx) => const Chart(),
          'Alert': (ctx) => const Alerts(),
          'User': (ctx) => const User(),
          'Success': (ctx) => const Success(),
          'Menu': (ctx) => const Menu(),
          'Start': (ctx) => const Start(),
          'MStart': (ctx) => const MStart(),
          'Email': (ctx) => const Email(),
          'Password': (ctx) => const Password(),
          'Otp': (ctx) => const OTP(),
          'ChangePassword': (ctx) => const ChangePassword(),
          'InstallESP': (ctx) => const InstallESP(),
          'Last24Hrs': (ctx) => const Last24Hour()
        });
  }
}
