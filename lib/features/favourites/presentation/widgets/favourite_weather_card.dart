import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../weather/data/repository/weather_repository_impl.dart';
import '../../../weather/domain/entities/weather_entity.dart';
import '../../../weather/presentation/widgets/dynamic_weather_icon.dart';

class FavouriteWeatherCard extends StatelessWidget {
  final String city;
  final WeatherRepositoryImpl repository;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const FavouriteWeatherCard({
    super.key,
    required this.city,
    required this.repository,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      accent: const Color(0xFF5C6BC0),
      padding: const EdgeInsets.all(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: FutureBuilder<WeatherEntity>(
          future: repository.getWeatherByCity(city),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return _errorTile(context);
            }
            final weather = snapshot.data!;
            return _content(context, weather);
          },
        ),
      ),
    );
  }

  Widget _errorTile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(city, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        const Text('Unable to load weather'),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onRemove,
          ),
        ),
      ],
    );
  }

  Widget _content(BuildContext context, WeatherEntity weather) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${weather.cityName}, ${weather.country}',
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onRemove,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconTheme(
              data: const IconThemeData(size: 34, color: Color(0xFF6B7A90)),
              child: DynamicWeatherIcon(condition: weather.description),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _sentenceCase(weather.description),
                    style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${weather.temperature.toStringAsFixed(0)}°C',
                    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _sentenceCase(String text) {
    if (text.isEmpty) return '';
    final lower = text.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }
}
