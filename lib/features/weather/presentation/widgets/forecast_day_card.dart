import 'package:flutter/material.dart';

class ForecastDayCard extends StatelessWidget {
  final String dateLabel;
  final double high;
  final double low;
  final String description;
  final String iconCode;

  const ForecastDayCard({
    super.key,
    required this.dateLabel,
    required this.high,
    required this.low,
    required this.description,
    required this.iconCode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(_mapIcon(iconCode)),
        title: Text(dateLabel),
        subtitle: Text(description),
        trailing: Text('${high.toStringAsFixed(0)}° / ${low.toStringAsFixed(0)}°'),
      ),
    );
  }

  IconData _mapIcon(String code) {
    if (code.contains('n')) return Icons.nights_stay_outlined;
    if (code.startsWith('09') || code.startsWith('10')) return Icons.umbrella_outlined;
    if (code.startsWith('11')) return Icons.bolt_outlined;
    if (code.startsWith('13')) return Icons.ac_unit_outlined;
    if (code.startsWith('50')) return Icons.blur_on_outlined;
    if (code.startsWith('02') || code.startsWith('03') || code.startsWith('04')) return Icons.cloud_outlined;
    return Icons.wb_sunny_outlined;
  }
}
