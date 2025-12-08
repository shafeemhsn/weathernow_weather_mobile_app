import 'package:flutter/material.dart';

class MetricsGrid extends StatelessWidget {
  final int humidity;
  final double windSpeed;
  final int pressure;

  const MetricsGrid({
    super.key,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
  });

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
      ),
      children: [
        _MetricTile(label: 'Humidity', value: humidity.toString() + '%'),
        _MetricTile(label: 'Wind', value: windSpeed.toStringAsFixed(1) + ' km/h'),
        _MetricTile(label: 'Pressure', value: pressure.toString() + ' hPa'),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;

  const _MetricTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
