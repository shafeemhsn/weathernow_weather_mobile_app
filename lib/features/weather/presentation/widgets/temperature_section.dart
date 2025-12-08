import 'package:flutter/material.dart';

class TemperatureSection extends StatelessWidget {
  final double temperature;
  final double feelsLike;
  final String description;
  final Widget? icon;

  const TemperatureSection({
    super.key,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD7E8FF), Color(0xFFE9F3FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${temperature.toStringAsFixed(0)}°C',
                  style: textTheme.headlineMedium?.copyWith(
                        fontSize: 52,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ) ??
                      const TextStyle(fontSize: 52, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: textTheme.bodyMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ) ??
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  'Feels like ${feelsLike.toStringAsFixed(0)}°C',
                  style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 12),
            icon!,
          ],
        ],
      ),
    );
  }
}
