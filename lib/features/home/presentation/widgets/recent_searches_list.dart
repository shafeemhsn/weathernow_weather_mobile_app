import 'package:flutter/material.dart';

import '../../../recent_searches/domain/entities/recent_search.dart';
import '../../../weather/data/repository/weather_repository_impl.dart';
import 'recent_search_card.dart';

class RecentSearchesList extends StatelessWidget {
  final List<RecentSearch> searches;
  final WeatherRepositoryImpl repository;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onForecast;
  final Future<bool> Function(String city)? isFavoriteProvider;
  final Future<void> Function(String city, bool isFavorite)? onToggleFavorite;

  const RecentSearchesList({
    super.key,
    required this.searches,
    required this.repository,
    required this.onSelect,
    required this.onRemove,
    required this.onForecast,
    this.isFavoriteProvider,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (searches.isEmpty) {
      return const Text(
        'No recent searches yet. Try looking up a city to see it here.',
        style: TextStyle(color: Colors.black54),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final search = searches[index];
        return RecentSearchCard(
          search: search,
          repository: repository,
          onRemove: () => onRemove(search.name),
          onOpenDetails: () => onSelect(search.name),
          onOpenForecast: () => onForecast(search.name),
          isFavoriteProvider: isFavoriteProvider,
          onToggleFavorite: onToggleFavorite,
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: searches.length,
    );
  }
}
