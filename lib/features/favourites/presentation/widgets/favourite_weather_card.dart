import 'package:flutter/material.dart';

import '../../../weather/data/repository/weather_repository_impl.dart';
import '../../../weather/presentation/widgets/city_weather_card.dart';

class FavouriteWeatherCard extends StatelessWidget {
  const FavouriteWeatherCard({
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
    return CityWeatherCard(
      city: city,
      repository: repository,
      onRemove: onRemove,
      onOpenDetails: onOpenDetails,
      onOpenForecast: onOpenForecast,
    );
  }
}
