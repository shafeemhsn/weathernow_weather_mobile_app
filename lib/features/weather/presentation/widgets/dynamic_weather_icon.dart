import 'package:flutter/material.dart';

class DynamicWeatherIcon extends StatelessWidget {
  final String condition;

  const DynamicWeatherIcon({super.key, required this.condition});

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.wb_sunny_outlined;
    if (condition.toLowerCase().contains('cloud')) {
      icon = Icons.cloud_outlined;
    } else if (condition.toLowerCase().contains('rain')) {
      icon = Icons.umbrella_outlined;
    }

    return Icon(icon, size: 64);
  }
}
