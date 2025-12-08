import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/cities.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../router/app_router.dart';
import '../../../../services/location_service.dart';
import '../widgets/city_search_bar.dart';
import '../widgets/quick_cities_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(AppStrings.appName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CitySearchBar(),
            SizedBox(height: 12),
            _CurrentLocationButton(),
            SizedBox(height: 16),
            SizedBox(height: 16),
            Text(AppStrings.quickCitiesTitle),
            SizedBox(height: 8),
            Expanded(child: QuickCitiesGrid(cities: quickCities)),
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
