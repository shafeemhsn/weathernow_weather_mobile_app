import 'package:flutter/material.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../router/app_router.dart';
import '../../../favourites/data/repository/favourites_repository_impl.dart';
import '../../../favourites/data/sources/favourites_local_source.dart';
import '../../../favourites/domain/usecases/add_favourite.dart';
import '../../../favourites/domain/usecases/get_favourites.dart';
import '../../../favourites/domain/usecases/is_favourite.dart';
import '../../../favourites/domain/usecases/remove_favourite.dart';
import '../../../favourites/presentation/viewmodel/favourites_viewmodel.dart';
import '../../data/repository/weather_repository_impl.dart';
import '../../data/sources/weather_api_service.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/usecases/get_weather_by_city.dart';
import '../../domain/usecases/get_weather_by_coords.dart';
import '../viewmodel/current_weather_viewmodel.dart';
import '../widgets/dynamic_weather_icon.dart';
import '../widgets/metrics_grid.dart';
import '../widgets/temperature_section.dart';

class CurrentWeatherScreen extends StatefulWidget {
  final String? city;
  final dynamic coords;

  const CurrentWeatherScreen({super.key, this.city, this.coords});

  @override
  State<CurrentWeatherScreen> createState() => _CurrentWeatherScreenState();
}

class _CurrentWeatherScreenState extends State<CurrentWeatherScreen> {
  late final CurrentWeatherViewModel _viewModel;
  late final FavouritesViewModel _favouritesViewModel;
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    final weatherRepo = WeatherRepositoryImpl(WeatherApiService(DioClient()));
    _viewModel = CurrentWeatherViewModel(
      GetWeatherByCity(weatherRepo),
      GetWeatherByCoords(weatherRepo),
    );

    final favRepo = FavouritesRepositoryImpl(FavouritesLocalSource());
    _favouritesViewModel = FavouritesViewModel(
      GetFavourites(favRepo),
      AddFavourite(favRepo),
      RemoveFavourite(favRepo),
      IsFavourite(favRepo),
    );

    _loadWeather();
  }

  Future<void> _loadWeather() async {
    if (widget.city != null && widget.city!.isNotEmpty) {
      await _viewModel.loadByCity(widget.city!);
    } else if (widget.coords != null) {
      final coords = _parseCoords(widget.coords);
      if (coords != null) {
        await _viewModel.loadByCoords(coords.$1, coords.$2);
      }
    }
    final cityName = _viewModel.weather?.cityName;
    if (cityName != null && cityName.isNotEmpty) {
      _isFavourite = await _favouritesViewModel.isFavourite(cityName);
      if (mounted) setState(() {});
    }
  }

  (double, double)? _parseCoords(dynamic coords) {
    if (coords is Map<String, dynamic>) {
      final lat = coords['lat'] as num?;
      final lon = coords['lon'] as num?;
      if (lat != null && lon != null) return (lat.toDouble(), lon.toDouble());
    } else if (coords is String && coords.contains(',')) {
      final parts = coords.split(',');
      if (parts.length == 2) {
        final lat = double.tryParse(parts[0]);
        final lon = double.tryParse(parts[1]);
        if (lat != null && lon != null) return (lat, lon);
      }
    }
    return null;
  }

  Future<void> _toggleFavourite(String city) async {
    if (_isFavourite) {
      await _favouritesViewModel.remove(city);
    } else {
      await _favouritesViewModel.add(city);
    }
    _isFavourite = await _favouritesViewModel.isFavourite(city);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Weather'),
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_viewModel.errorMessage != null) {
            return Center(child: Text(_viewModel.errorMessage!));
          }
          final weather = _viewModel.weather;
          if (weather == null) {
            return const Center(child: Text('No weather data'));
          }
          return _WeatherContent(
            weather: weather,
            isFavourite: _isFavourite,
            onToggleFavourite: () => _toggleFavourite(weather.cityName),
            onViewForecast: () => Navigator.of(context).pushNamed(
              AppRouter.forecast,
              arguments: {'city': weather.cityName},
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
            final city = _viewModel.weather?.cityName;
            if (city != null && city.isNotEmpty) {
              Navigator.of(context).pushReplacementNamed(
                AppRouter.forecast,
                arguments: {'city': city},
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Load a city to view forecast')),
              );
            }
          } else if (index == 3) {
            Navigator.of(context).pushReplacementNamed(AppRouter.favourites);
          } else if (index == 4) {
            Navigator.of(context).pushReplacementNamed(AppRouter.settings);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _favouritesViewModel.dispose();
    super.dispose();
  }
}

class _WeatherContent extends StatelessWidget {
  final WeatherEntity weather;
  final bool isFavourite;
  final VoidCallback onToggleFavourite;
  final VoidCallback onViewForecast;

  const _WeatherContent({
    required this.weather,
    required this.isFavourite,
    required this.onToggleFavourite,
    required this.onViewForecast,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${weather.cityName}, ${weather.country}',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 4),
                    Text(weather.description, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(isFavourite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                onPressed: onToggleFavourite,
              ),
            ],
          ),
          const SizedBox(height: 16),
          DynamicWeatherIcon(condition: weather.description),
          const SizedBox(height: 16),
          TemperatureSection(temperature: weather.temperature, feelsLike: weather.feelsLike),
          const SizedBox(height: 8),
          Text('Feels like with wind chill and humidity'),
          const SizedBox(height: 16),
          MetricsGrid(
            humidity: weather.humidity,
            windSpeed: weather.windSpeed,
            windDirection: weather.windDirection,
            pressure: weather.pressure,
            visibility: weather.visibility,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onViewForecast,
              icon: const Icon(Icons.calendar_today),
              label: const Text('View 5-day forecast'),
            ),
          ),
        ],
      ),
    );
  }
}
