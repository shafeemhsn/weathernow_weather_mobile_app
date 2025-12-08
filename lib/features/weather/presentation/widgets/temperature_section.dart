import 'package:flutter/material.dart';

class TemperatureSection extends StatelessWidget {
  final double temperature;
  final double feelsLike;

  const TemperatureSection({
    super.key,
    required this.temperature,
    required this.feelsLike,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('${temperature.toStringAsFixed(1)}°', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(width: 8),
        Text('Feels like ${feelsLike.toStringAsFixed(1)}°'),
      ],
    );
  }
}
