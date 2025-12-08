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
    final double availableWidth = MediaQuery.of(context).size.width;
    final double cardWidth = ((availableWidth - 32) - 12) / 2;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _MetricCard(
          width: cardWidth,
          title: 'Humidity',
          value: '${humidity.toString()}%',
          subtitle: _humidityDescription(humidity),
          icon: Icons.water_drop_outlined,
          accent: const Color(0xFF5C6BC0),
          progress: _clampProgress(humidity / 100),
        ),
        _MetricCard(
          width: cardWidth,
          title: 'Wind Speed',
          value: '${windSpeed.toStringAsFixed(1)} m/s ${_directionFromDegrees(windDirection)}',
          subtitle: _windDescription(windSpeed),
          icon: Icons.air_rounded,
          accent: const Color(0xFF26A69A),
          progress: _clampProgress(windSpeed / 20),
        ),
        _MetricCard(
          width: cardWidth,
          title: 'Pressure',
          value: '$pressure hPa',
          subtitle: _pressureDescription(pressure),
          icon: Icons.speed_rounded,
          accent: const Color(0xFF42A5F5),
          progress: _clampProgress((pressure - 950) / 100),
        ),
        _MetricCard(
          width: cardWidth,
          title: 'Visibility',
          value: '${(visibility / 1000).toStringAsFixed(1)} km',
          subtitle: _visibilityDescription(visibility),
          icon: Icons.visibility_outlined,
          accent: const Color(0xFFAB47BC),
          progress: _clampProgress(visibility / 10000),
        ),
      ],
    );
  }

  String _humidityDescription(int value) {
    if (value >= 80) return 'Very humid';
    if (value >= 60) return 'Comfortable';
    if (value >= 40) return 'Pleasant';
    return 'Dry';
  }

  String _windDescription(double speed) {
    if (speed >= 15) return 'Strong';
    if (speed >= 8) return 'Windy';
    if (speed >= 4) return 'Breezy';
    return 'Calm';
  }

  String _pressureDescription(int value) {
    if (value >= 1030) return 'High pressure';
    if (value >= 1000) return 'Stable';
    return 'Low pressure';
  }

  String _visibilityDescription(int value) {
    if (value >= 9000) return 'Clear view';
    if (value >= 5000) return 'Good visibility';
    return 'Low visibility';
  }

  String _directionFromDegrees(int degrees) {
    const dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((degrees % 360) / 45).round() % dirs.length;
    return dirs[index];
  }

  double _clampProgress(double value) => value.clamp(0.0, 1.0);
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final double progress;
  final double width;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.progress,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final constrainedWidth = width.clamp(150.0, double.infinity);

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: constrainedWidth, maxWidth: constrainedWidth),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [accent.withOpacity(0.12), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accent, size: 22),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ) ??
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: textTheme.headlineMedium?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ) ??
                  const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: accent.withOpacity(0.12),
                color: accent,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: textTheme.bodyMedium?.copyWith(color: Colors.black54) ??
                  const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
