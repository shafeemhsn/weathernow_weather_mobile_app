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
import '../../../../core/network/dio_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final RecentSearchesViewModel _recentSearchesViewModel;
  late final WeatherRepositoryImpl _weatherRepository;

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
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              return;
            case 1:
              Navigator.of(context).pushReplacementNamed(AppRouter.weather);
              break;
            case 2:
              Navigator.of(context).pushReplacementNamed(AppRouter.forecast);
              break;
            case 3:
              Navigator.of(context).pushReplacementNamed(AppRouter.favourites);
              break;
            case 4:
              Navigator.of(context).pushReplacementNamed(AppRouter.settings);
              break;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _recentSearchesViewModel.dispose();
    super.dispose();
  }
}
