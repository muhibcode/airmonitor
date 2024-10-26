import 'package:air_monitor/config.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class SleekSlide extends StatelessWidget {
  final label;
  final gvalue;
  final tvalue;
  const SleekSlide({super.key, this.label, this.gvalue, this.tvalue});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ClayContainer(
        height: 100,
        width: 100,
        color: primaryColor,
        borderRadius: 200,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SleekCircularSlider(
              initialValue: gvalue,
              max: 5000,
              appearance: CircularSliderAppearance(
                size: 90,
                customColors: CustomSliderColors(
                  progressBarColors: gradientColors,
                  hideShadow: true,
                  shadowColor: Colors.transparent,
                ),
                infoProperties: InfoProperties(
                    mainLabelStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                    bottomLabelText: gvalue > tvalue ? 'HIGH' : 'USUAL',
                    bottomLabelStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    modifier: (double value) {
                      final roundedValue = value.ceil().toInt().toString();

                      return roundedValue;
                    }),
              ),
              onChange: (double value) {
                print(value);
              }),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    ]);
  }
}
