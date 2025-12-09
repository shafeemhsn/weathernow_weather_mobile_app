import 'package:flutter/material.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../router/app_router.dart';
import '../../../weather/data/repository/weather_repository_impl.dart';
import '../../../weather/data/sources/weather_api_service.dart';
import '../../data/repository/favourites_repository_impl.dart';
import '../../data/sources/favourites_local_source.dart';
import '../../domain/entities/favourite_city.dart';
import '../../domain/usecases/add_favourite.dart';
import '../../domain/usecases/get_favourites.dart';
import '../../domain/usecases/is_favourite.dart';
import '../../domain/usecases/remove_favourite.dart';
import '../viewmodel/favourites_viewmodel.dart';
import '../widgets/favourite_weather_card.dart';
import '../widgets/favourites_search_field.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late final FavouritesViewModel _viewModel;
  late final WeatherRepositoryImpl _weatherRepository;

  @override
  void initState() {
    super.initState();
    final favRepo = FavouritesRepositoryImpl(FavouritesLocalSource());
    _viewModel = FavouritesViewModel(
      GetFavourites(favRepo),
      AddFavourite(favRepo),
      RemoveFavourite(favRepo),
      IsFavourite(favRepo),
    );
    _weatherRepository = WeatherRepositoryImpl(WeatherApiService(DioClient()));
    _viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Favorites'),
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          final favourites = _viewModel.favourites;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FavouritesSearchField(onSearch: (value) => _viewModel.filter(value)),
                const SizedBox(height: 12),
                Text('Matches: ${favourites.length}'),
                const SizedBox(height: 12),
                Expanded(
                  child: favourites.isEmpty
                      ? const Center(child: Text('No favourites yet. Add some cities!'))
                      : ListView.separated(
                          itemCount: favourites.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final favourite = favourites[index];
                            return FavouriteWeatherCard(
                              city: favourite.name,
                              repository: _weatherRepository,
                              onRemove: () => _remove(favourite),
                              onOpenDetails: () => _openDetails(favourite),
                              onOpenForecast: () => _openForecast(favourite.name),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
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
    await _viewModel.remove(city.name);
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
    await _viewModel.load(query: _viewModel.searchQuery);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
