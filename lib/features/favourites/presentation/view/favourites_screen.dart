import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../router/app_router.dart';
import '../../domain/entities/favourite_city.dart';
import '../widgets/favourite_weather_card.dart';
import '../widgets/favourites_search_field.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(favouritesViewModelProvider).load());
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(favouritesViewModelProvider);
    final weatherRepository = ref.read(weatherRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Favorites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FavouritesSearchField(onSearch: (value) => viewModel.filter(value)),
            const SizedBox(height: 12),
            Text('Matches: ${viewModel.favourites.length}'),
            const SizedBox(height: 12),
            Expanded(
              child: viewModel.favourites.isEmpty
                  ? const Center(child: Text('No favourites yet. Add some cities!'))
                  : ListView.separated(
                      itemCount: viewModel.favourites.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final favourite = viewModel.favourites[index];
                        return FavouriteWeatherCard(
                          city: favourite.name,
                          repository: weatherRepository,
                          onRemove: () => _remove(favourite),
                          onOpenDetails: () => _openDetails(favourite),
                          onOpenForecast: () => _openForecast(favourite.name),
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

  Future<void> _remove(FavouriteCity city) async {
    await ref.read(favouritesViewModelProvider).remove(city.name);
  }

  Future<void> _openDetails(FavouriteCity city) async {
    await Navigator.of(context).pushNamed(AppRouter.weather, arguments: {'city': city.name});
    await _refresh();
  }

  Future<void> _openForecast(String city) async {
    await Navigator.of(context).pushNamed(AppRouter.forecast, arguments: {'city': city});
    await _refresh();
  }

  Future<void> _refresh() async {
    final viewModel = ref.read(favouritesViewModelProvider);
    await viewModel.load(query: viewModel.searchQuery);
  }
}
