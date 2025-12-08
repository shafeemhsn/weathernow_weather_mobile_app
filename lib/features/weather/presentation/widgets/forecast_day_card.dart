import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';

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
    final textTheme = Theme.of(context).textTheme;
    final iconData = _mapIcon(iconCode);

    return AppCard(
      accent: const Color(0xFF6C8BFF),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF6C8BFF).withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, size: 30, color: const Color(0xFF3F5FBF)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateLabel,
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  _sentenceCase(description),
                  style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${high.toStringAsFixed(0)}°C',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                '${low.toStringAsFixed(0)}°C',
                style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
              ),
            ],
          ),
        ],
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

  String _sentenceCase(String text) {
    if (text.isEmpty) return '';
    final lower = text.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }
}
