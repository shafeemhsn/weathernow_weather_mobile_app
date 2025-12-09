import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../router/app_router.dart';
import '../../domain/entities/weather_entity.dart';
import '../widgets/city_not_found_card.dart';
import '../widgets/dynamic_weather_icon.dart';
import '../widgets/metrics_grid.dart';
import '../widgets/temperature_section.dart';

class CurrentWeatherScreen extends ConsumerStatefulWidget {
  final String? city;
  final dynamic coords;

  const CurrentWeatherScreen({super.key, this.city, this.coords});

  @override
  ConsumerState<CurrentWeatherScreen> createState() =>
      _CurrentWeatherScreenState();
}

class _CurrentWeatherScreenState extends ConsumerState<CurrentWeatherScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadWeather);
  }

  Future<void> _loadWeather() async {
    _isFavorite = false;
    final viewModel = ref.read(currentWeatherViewModelProvider);
    if (widget.city != null && widget.city!.isNotEmpty) {
      await viewModel.loadByCity(widget.city!);
    } else if (widget.coords != null) {
      final coords = _parseCoords(widget.coords);
      if (coords != null) {
        await viewModel.loadByCoords(coords.$1, coords.$2);
      }
    }
    final cityName = viewModel.weather?.cityName;
    if (cityName != null && cityName.isNotEmpty) {
      await ref.read(addRecentSearchProvider).call(cityName);
      // Refresh recent searches so the home screen list updates immediately after returning.
      await ref.read(recentSearchesViewModelProvider).load();
      _isFavorite = await ref
          .read(favoritesViewModelProvider)
          .isFavorite(cityName);
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

  bool _isCityNotFound(String? message) {
    if (message == null) return false;
    final lower = message.toLowerCase();
    return lower.contains('city not found') || lower.contains('404');
  }

  void _goBackToSearch() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRouter.home);
    }
  }

  Future<void> _toggleFavorite(String city) async {
    final target = !_isFavorite;
    if (mounted) {
      setState(() {
        _isFavorite = target;
      });
    }
    if (target) {
      await ref.read(favoritesViewModelProvider).add(city);
    } else {
      await ref.read(favoritesViewModelProvider).remove(city);
    }
    final persisted = await ref
        .read(favoritesViewModelProvider)
        .isFavorite(city);
    if (mounted) {
      setState(() {
        _isFavorite = persisted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(currentWeatherViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBack,
        ),
        title: const Text('Weather'),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.errorMessage != null
          ? _buildError(viewModel.errorMessage!)
          : _buildContent(viewModel.weather),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed(AppRouter.home);
          } else if (index == 1) {
            Navigator.of(context).pushReplacementNamed(AppRouter.favorites);
          } else if (index == 2) {
            Navigator.of(context).pushReplacementNamed(AppRouter.settings);
          }
        },
      ),
    );
  }

  void _handleBack() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRouter.home);
    }
  }

  Widget _buildError(String message) {
    if (_isCityNotFound(message)) {
      return CityNotFoundCard(
        city: widget.city,
        onSearchAgain: _goBackToSearch,
      );
    }
    return ErrorStateWidget(message: message, onRetry: _loadWeather);
  }

  Widget _buildContent(WeatherEntity? weather) {
    if (weather == null) {
      return const Center(child: Text('No weather data'));
    }
    return _WeatherContent(
      weather: weather,
      isFavorite: _isFavorite,
      onToggleFavorite: () => _toggleFavorite(weather.cityName),
      onViewForecast: () => Navigator.of(
        context,
      ).pushNamed(AppRouter.forecast, arguments: {'city': weather.cityName}),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  final WeatherEntity weather;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onViewForecast;

  const _WeatherContent({
    required this.weather,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onViewForecast,
  });

  String _sentenceCase(String text) {
    if (text.isEmpty) return '';
    final lower = text.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF5F8FF), Color(0xFFEAF1FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.cityName}, ${weather.country}',
                        style: textTheme.headlineMedium?.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Current Weather',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.redAccent,
                  ),
                  onPressed: onToggleFavorite,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TemperatureSection(
              temperature: weather.temperature,
              feelsLike: weather.feelsLike,
              description: _sentenceCase(weather.description),
              icon: IconTheme(
                data: const IconThemeData(size: 70, color: Color(0xFF6B7A90)),
                child: DynamicWeatherIcon(condition: weather.description),
              ),
            ),
            const SizedBox(height: 16),
            MetricsGrid(
              humidity: weather.humidity,
              windSpeed: weather.windSpeed,
              windDirection: weather.windDirection,
              pressure: weather.pressure,
              visibility: weather.visibility,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onViewForecast,
                icon: const Icon(Icons.calendar_month_outlined),
                label: const Text('View 5-day forecast'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
