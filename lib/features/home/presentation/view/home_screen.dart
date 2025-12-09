import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_brand.dart';
import '../../../../router/app_router.dart';
import '../widgets/city_search_bar.dart';
import '../widgets/recent_searches_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(recentSearchesViewModelProvider).load());
  }

  Future<void> _refreshRecent() async {
    await ref.read(recentSearchesViewModelProvider).load();
  }

  Future<void> _openRecentSearch(String city) async {
    await Navigator.of(
      context,
    ).pushNamed(AppRouter.weather, arguments: {'city': city});
    await _refreshRecent();
  }

  Future<void> _openForecast(String city) async {
    await Navigator.of(
      context,
    ).pushNamed(AppRouter.forecast, arguments: {'city': city});
    await _refreshRecent();
  }

  Future<void> _removeRecent(String city) async {
    await ref.read(recentSearchesViewModelProvider).remove(city);
  }

  Future<bool> _isFavorite(String city) {
    return ref.read(favoritesViewModelProvider).isFavorite(city);
  }

  Future<void> _toggleFavorite(String city, bool isFavorite) async {
    if (isFavorite) {
      await ref.read(favoritesViewModelProvider).remove(city);
    } else {
      await ref.read(favoritesViewModelProvider).add(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recentSearchesViewModel = ref.watch(recentSearchesViewModelProvider);
    final weatherRepository = ref.read(weatherRepositoryProvider);
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: const AppBrand()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CitySearchBar(onSearchCompleted: _refreshRecent),
            const SizedBox(height: 24),
            Text(
              'Recently searched',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            RecentSearchesList(
              searches: recentSearchesViewModel.recentSearches,
              repository: weatherRepository,
              onSelect: _openRecentSearch,
              onRemove: _removeRecent,
              onForecast: _openForecast,
              isFavoriteProvider: _isFavorite,
              onToggleFavorite: _toggleFavorite,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).pushReplacementNamed(AppRouter.favorites);
          } else if (index == 2) {
            Navigator.of(context).pushReplacementNamed(AppRouter.settings);
          }
        },
      ),
    );
  }
}
