import 'package:flutter/material.dart';

import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_brand.dart';
import '../../../../router/app_router.dart';
import '../widgets/city_search_bar.dart';
import '../widgets/recent_searches_list.dart';
import '../../../recent_searches/data/repository/recent_searches_repository_impl.dart';
import '../../../recent_searches/data/sources/recent_searches_local_source.dart';
import '../../../recent_searches/domain/usecases/clear_recent_searches.dart';
import '../../../recent_searches/domain/usecases/get_recent_searches.dart';
import '../../../recent_searches/domain/usecases/remove_recent_search.dart';
import '../../../recent_searches/presentation/viewmodel/recent_searches_viewmodel.dart';
import '../../../weather/data/repository/weather_repository_impl.dart';
import '../../../weather/data/sources/weather_api_service.dart';
import '../../../favourites/data/repository/favourites_repository_impl.dart';
import '../../../favourites/data/sources/favourites_local_source.dart';
import '../../../favourites/domain/usecases/add_favourite.dart';
import '../../../favourites/domain/usecases/get_favourites.dart';
import '../../../favourites/domain/usecases/is_favourite.dart';
import '../../../favourites/domain/usecases/remove_favourite.dart';
import '../../../favourites/presentation/viewmodel/favourites_viewmodel.dart';
import '../../../../core/network/dio_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final RecentSearchesViewModel _recentSearchesViewModel;
  late final WeatherRepositoryImpl _weatherRepository;
  late final FavouritesViewModel _favouritesViewModel;

  @override
  void initState() {
    super.initState();
    final recentRepo = RecentSearchesRepositoryImpl(RecentSearchesLocalSource());
    _recentSearchesViewModel = RecentSearchesViewModel(
      GetRecentSearches(recentRepo),
      ClearRecentSearches(recentRepo),
      RemoveRecentSearch(recentRepo),
    );
    _weatherRepository = WeatherRepositoryImpl(WeatherApiService(DioClient()));
    final favouritesRepo = FavouritesRepositoryImpl(FavouritesLocalSource());
    _favouritesViewModel = FavouritesViewModel(
      GetFavourites(favouritesRepo),
      AddFavourite(favouritesRepo),
      RemoveFavourite(favouritesRepo),
      IsFavourite(favouritesRepo),
    );
    _recentSearchesViewModel.load();
  }

  Future<void> _refreshRecents() async {
    await _recentSearchesViewModel.load();
  }

  Future<void> _openRecentSearch(String city) async {
    await Navigator.of(context).pushNamed(AppRouter.weather, arguments: {'city': city});
    await _refreshRecents();
  }

  Future<void> _openForecast(String city) async {
    await Navigator.of(context).pushNamed(AppRouter.forecast, arguments: {'city': city});
    await _refreshRecents();
  }

  Future<void> _removeRecent(String city) async {
    await _recentSearchesViewModel.remove(city);
  }

  Future<bool> _isFavourite(String city) {
    return _favouritesViewModel.isFavourite(city);
  }

  Future<void> _toggleFavourite(String city, bool isFavourite) async {
    if (isFavourite) {
      await _favouritesViewModel.remove(city);
    } else {
      await _favouritesViewModel.add(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const AppBrand(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CitySearchBar(onSearchCompleted: _refreshRecents),
            const SizedBox(height: 24),
            Text(
              'Recently searched',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: _recentSearchesViewModel,
              builder: (context, _) => RecentSearchesList(
                searches: _recentSearchesViewModel.recentSearches,
                repository: _weatherRepository,
                onSelect: _openRecentSearch,
                onRemove: _removeRecent,
                onForecast: _openForecast,
                isFavouriteProvider: _isFavourite,
                onToggleFavourite: _toggleFavourite,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).pushReplacementNamed(AppRouter.favourites);
          } else if (index == 2) {
            Navigator.of(context).pushReplacementNamed(AppRouter.settings);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _recentSearchesViewModel.dispose();
    _favouritesViewModel.dispose();
    super.dispose();
  }
}
