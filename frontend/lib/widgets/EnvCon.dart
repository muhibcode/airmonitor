import 'package:flutter/material.dart';

class EnvCon extends StatelessWidget {
  final String title;
  final Color color;

  const EnvCon({super.key, required this.title, required this.color});
  showColor(name, val) {
    Color col = Colors.white;
    if (name == 'CO') {
      if (val > 1000) {
        col = Colors.red;
      }
    }
    if (name == 'CH4') {
      if (val > 1000) {
        col = Colors.red;
      }
    }
    if (name == 'LPG') {
      if (val > 1000) {
        col = Colors.red;
      }
    }
    if (name == 'Smoke') {
      if (val > 1000) {
        col = Colors.red;
      }
    }
    return col;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 6),
          Container(
            // width: 50,
            height: 20,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          )
        ],
      ),
    );
  }
}
