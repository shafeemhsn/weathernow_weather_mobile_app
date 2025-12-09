import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../router/app_router.dart';
import '../../domain/entities/favorite_city.dart';
import '../widgets/favorites_weather_card.dart';
import '../widgets/favorites_search_field.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(favoritesViewModelProvider).load());
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(favoritesViewModelProvider);
    final weatherRepository = ref.read(weatherRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(AppStrings.favoritesTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FavoritesSearchField(onSearch: (value) => viewModel.filter(value)),
            const SizedBox(height: 12),
            Text('Matches: ${viewModel.favorites.length}'),
            const SizedBox(height: 12),
            Expanded(
              child: viewModel.favorites.isEmpty
                  ? const Center(
                      child: Text('No favorites yet. Add some cities!'),
                    )
                  : ListView.separated(
                      itemCount: viewModel.favorites.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final favorite = viewModel.favorites[index];
                        return FavoriteWeatherCard(
                          city: favorite.name,
                          repository: weatherRepository,
                          onRemove: () => _remove(favorite),
                          onOpenDetails: () => _openDetails(favorite),
                          onOpenForecast: () => _openForecast(favorite.name),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed(AppRouter.home);
          } else if (index == 2) {
            Navigator.of(context).pushReplacementNamed(AppRouter.settings);
          }
        },
      ),
    );
  }

  Future<void> _remove(FavoriteCity city) async {
    await ref.read(favoritesViewModelProvider).remove(city.name);
  }

  Future<void> _openDetails(FavoriteCity city) async {
    await Navigator.of(
      context,
    ).pushNamed(AppRouter.weather, arguments: {'city': city.name});
    await _refresh();
  }

  Future<void> _openForecast(String city) async {
    await Navigator.of(
      context,
    ).pushNamed(AppRouter.forecast, arguments: {'city': city});
    await _refresh();
  }

  Future<void> _refresh() async {
    final viewModel = ref.read(favoritesViewModelProvider);
    await viewModel.load(query: viewModel.searchQuery);
  }
}
