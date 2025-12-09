import 'package:flutter/material.dart';

import '../../../recent_searches/domain/entities/recent_search.dart';
import '../../../weather/data/repository/weather_repository_impl.dart';
import '../../../weather/presentation/widgets/city_weather_card.dart';

class RecentSearchCard extends StatelessWidget {
  final RecentSearch search;
  final WeatherRepositoryImpl repository;
  final VoidCallback onRemove;
  final VoidCallback onOpenDetails;
  final VoidCallback onOpenForecast;

  const RecentSearchCard({
    super.key,
    required this.search,
    required this.repository,
    required this.onRemove,
    required this.onOpenDetails,
    required this.onOpenForecast,
  });

  @override
  Widget build(BuildContext context) {
    return CityWeatherCard(
      city: search.name,
      repository: repository,
      onRemove: onRemove,
      onOpenDetails: onOpenDetails,
      onOpenForecast: onOpenForecast,
    );
  }
}
