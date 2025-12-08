import 'package:flutter/material.dart';

class ForecastDayCard extends StatelessWidget {
  final String dateLabel;
  final double high;
  final double low;
  final String description;

  const ForecastDayCard({
    super.key,
    required this.dateLabel,
    required this.high,
    required this.low,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(dateLabel),
        subtitle: Text(description),
        trailing: Text('${high.toStringAsFixed(0)}? / ${low.toStringAsFixed(0)}?'),
      ),
    );
  }
}
