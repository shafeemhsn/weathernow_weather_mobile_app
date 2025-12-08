import 'package:flutter/material.dart';

import '../../../weather/data/repository/weather_repository_impl.dart';
import '../../../weather/domain/entities/weather_entity.dart';

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
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FutureBuilder<WeatherEntity>(
            future: repository.getWeatherByCity(city),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(strokeWidth: 2));
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return _errorTile(context);
              }
              final weather = snapshot.data!;
              return _content(context, weather);
            },
          ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onRemove,
            ),
          ],
        ),
      ],
    );
  }

  Widget _content(BuildContext context, WeatherEntity weather) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${weather.cityName}, ${weather.country}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Icon(_iconFor(weather.icon, weather.description)),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onRemove,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(weather.description),
        const SizedBox(height: 8),
        Text('${weather.temperature.toStringAsFixed(1)}°'),
      ],
    );
  }

  IconData _iconFor(String code, String description) {
    if (code.startsWith('09') || code.startsWith('10')) return Icons.umbrella_outlined;
    if (code.startsWith('11')) return Icons.bolt_outlined;
    if (code.startsWith('13')) return Icons.ac_unit_outlined;
    if (code.startsWith('50')) return Icons.blur_on_outlined;
    if (code.startsWith('02') || code.startsWith('03') || code.startsWith('04')) {
      return Icons.cloud_outlined;
    }
    if (description.toLowerCase().contains('night')) return Icons.nights_stay_outlined;
    return Icons.wb_sunny_outlined;
  }
}
