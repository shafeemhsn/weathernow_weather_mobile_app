import 'package:flutter/material.dart';

class MetricsGrid extends StatelessWidget {
  final int humidity;
  final double windSpeed;
  final int windDirection;
  final int pressure;
  final int visibility;

  const MetricsGrid({
    super.key,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.pressure,
    required this.visibility,
  });

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
      ),
      children: [
        _MetricTile(label: 'Humidity', value: humidity.toString() + '%'),
        _MetricTile(
          label: 'Wind',
          value: windSpeed.toStringAsFixed(1) + ' km/h ' + _directionFromDegrees(windDirection),
        ),
        _MetricTile(label: 'Pressure', value: pressure.toString() + ' hPa'),
        _MetricTile(label: 'Visibility', value: (visibility / 1000).toStringAsFixed(1) + ' km'),
      ],
    );
  }

  String _directionFromDegrees(int degrees) {
    const dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((degrees % 360) / 45).round() % dirs.length;
    return dirs[index];
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
