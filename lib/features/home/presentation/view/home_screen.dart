import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../router/app_router.dart';
import '../../../../services/location_service.dart';
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
        title: const Text(AppStrings.appName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CitySearchBar(onSearchCompleted: _refreshRecents),
            const SizedBox(height: 12),
            const _CurrentLocationButton(),
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

class _CurrentLocationButton extends StatefulWidget {
  const _CurrentLocationButton();

  @override
  State<_CurrentLocationButton> createState() => _CurrentLocationButtonState();
}

class _CurrentLocationButtonState extends State<_CurrentLocationButton> {
  bool _loading = false;
  final LocationService _locationService = LocationService();

  Future<void> _fetchLocation() async {
    setState(() => _loading = true);
    try {
      final position = await _locationService.getCurrentCoordinates();
      if (!mounted) return;
      Navigator.of(context).pushNamed(
        AppRouter.weather,
        arguments: {
          'coords': {'lat': position.latitude, 'lon': position.longitude},
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to get location: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _loading ? null : _fetchLocation,
        icon: _loading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.my_location),
        label: Text(_loading ? 'Detecting...' : 'Use current location'),
      ),
    );
  }
}
