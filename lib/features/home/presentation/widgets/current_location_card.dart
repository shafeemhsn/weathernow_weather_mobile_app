import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../router/app_router.dart';
import '../../../../services/location_service.dart';
import '../../../weather/data/repository/weather_repository_impl.dart';
import '../../../weather/domain/entities/weather_entity.dart';
import '../../../weather/presentation/widgets/city_weather_card.dart';

class CurrentLocationCard extends ConsumerStatefulWidget {
  const CurrentLocationCard({
    super.key,
    required this.repository,
    this.isFavoriteProvider,
    this.onToggleFavorite,
  });

  final WeatherRepositoryImpl repository;
  final Future<bool> Function(String city)? isFavoriteProvider;
  final Future<void> Function(String city, bool isFavorite)? onToggleFavorite;

  @override
  ConsumerState<CurrentLocationCard> createState() =>
      _CurrentLocationCardState();
}

class _CurrentLocationCardState extends ConsumerState<CurrentLocationCard> {
  final LocationService _locationService = LocationService();

  WeatherEntity? _weather;
  (double, double)? _coords;
  String? _error;
  bool _loading = true;

  static WeatherEntity? _cachedWeather;
  static (double, double)? _cachedCoords;
  static String? _cachedError;

  @override
  void initState() {
    super.initState();
    _hydrateFromCache();
    if (_weather == null && _error == null) {
      _loadCurrentLocationWeather();
    }
  }

  void _hydrateFromCache() {
    if (_cachedWeather != null || _cachedError != null) {
      setState(() {
        _weather = _cachedWeather;
        _coords = _cachedCoords;
        _error = _cachedError;
        _loading = false;
      });
    }
  }

  Future<void> _loadCurrentLocationWeather({bool force = false}) async {
    if (!force && _cachedWeather != null) {
      _hydrateFromCache();
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final position = await _locationService.getCurrentCoordinates();
      final weather = await widget.repository.getWeatherByCoords(
        position.latitude,
        position.longitude,
      );
      if (!mounted) return;
      setState(() {
        _coords = (position.latitude, position.longitude);
        _weather = weather;
        _cachedCoords = _coords;
        _cachedWeather = weather;
        _cachedError = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _coords = null;
        _weather = null;
        _cachedCoords = null;
        _cachedWeather = null;
        _cachedError = _error;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> refresh() => _loadCurrentLocationWeather(force: true);

  void _openDetails() {
    final coords = _coords;
    if (coords == null) return;
    Navigator.of(context).pushNamed(
      AppRouter.weather,
      arguments: {
        'coords': {'lat': coords.$1, 'lon': coords.$2},
      },
    );
  }

  void _openForecast() {
    final city = _weather?.cityName;
    if (city == null || city.isEmpty) return;
    Navigator.of(context)
        .pushNamed(AppRouter.forecast, arguments: {'city': city});
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return AppCard(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: const SizedBox(
          height: 110,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
    }

    if (_error != null) {
      return AppCard(
        accent: const Color(0xFF9E9E9E),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Unable to detect your location right now'),
            const SizedBox(height: 6),
            Text(
              _error!,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _loadCurrentLocationWeather,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ),
          ],
        ),
      );
    }

    if (_weather == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Current location',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh location',
              onPressed: _loading ? null : () => refresh(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        CityWeatherCard(
          city: _weather!.cityName,
          repository: widget.repository,
          initialWeather: _weather,
          coords: _coords,
          showRemoveAction: false,
          onOpenDetails: _openDetails,
          onOpenForecast: _openForecast,
          showFavoriteAction: widget.isFavoriteProvider != null &&
              widget.onToggleFavorite != null,
          isFavoriteProvider: widget.isFavoriteProvider,
          onToggleFavorite: widget.onToggleFavorite,
        ),
      ],
    );
  }
}
