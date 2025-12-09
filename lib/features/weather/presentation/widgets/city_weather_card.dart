import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../data/repository/weather_repository_impl.dart';
import '../../domain/entities/weather_entity.dart';
import 'dynamic_weather_icon.dart';

class CityWeatherCard extends StatelessWidget {
  const CityWeatherCard({
    super.key,
    required this.city,
    required this.repository,
    required this.onRemove,
    required this.onOpenDetails,
    required this.onOpenForecast,
  });

  final String city;
  final WeatherRepositoryImpl repository;
  final VoidCallback onRemove;
  final VoidCallback onOpenDetails;
  final VoidCallback onOpenForecast;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherEntity>(
      future: repository.getWeatherByCity(city),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppCard(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: const SizedBox(
              height: 110,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return AppCard(
            accent: const Color(0xFF9E9E9E),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: _errorContent(context),
          );
        }
        final weather = snapshot.data!;
        return AppCard(
          accent: _toneFor(weather.description),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: _content(context, weather),
        );
      },
    );
  }

  Widget _errorContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Unable to load weather right now'),
        const SizedBox(height: 8),
        _actions(context, disabledForecast: true),
      ],
    );
  }

  Widget _content(BuildContext context, WeatherEntity weather) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_outlined, color: Colors.black54),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '${weather.cityName}, ${weather.country}',
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: onRemove,
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconTheme(
              data: const IconThemeData(size: 30, color: Color(0xFF6B7A90)),
              child: DynamicWeatherIcon(condition: weather.description),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weather.temperature.toStringAsFixed(0)}°C',
                  style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                Text(
                  _sentenceCase(weather.description),
                  style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.water_drop, size: 18, color: Colors.lightBlue),
                    const SizedBox(width: 4),
                    Text('${weather.humidity.toStringAsFixed(0)}%'),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        _actions(context),
      ],
    );
  }

  Widget _actions(BuildContext context, {bool disabledForecast = false}) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: onOpenDetails,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('View Details'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: disabledForecast ? null : onOpenForecast,
            icon: const Icon(Icons.auto_graph),
            label: const Text('Forecast'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  String _sentenceCase(String text) {
    if (text.isEmpty) return '';
    final lower = text.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }

  Color _toneFor(String description) {
    final lower = description.toLowerCase();
    if (lower.contains('thunder')) return const Color(0xFF6C63FF);
    if (lower.contains('rain') || lower.contains('drizzle')) return const Color(0xFF1E88E5);
    if (lower.contains('snow')) return const Color(0xFF90CAF9);
    if (lower.contains('cloud')) return const Color(0xFF546E7A);
    if (lower.contains('clear')) return const Color(0xFFFFB300);
    return const Color(0xFF00838F);
  }
}
