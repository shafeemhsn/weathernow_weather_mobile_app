import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../router/app_router.dart';
import '../../../../services/location_service.dart';

class CitySearchBar extends StatefulWidget {
  final Future<void> Function()? onSearchCompleted;

  const CitySearchBar({super.key, this.onSearchCompleted});

  @override
  State<CitySearchBar> createState() => _CitySearchBarState();
}

class _CitySearchBarState extends State<CitySearchBar> {
  final TextEditingController _controller = TextEditingController();
  final LocationService _locationService = LocationService();
  bool _loadingLocation = false;

  Future<void> _performSearch(String value) async {
    final query = value.trim();
    if (query.isEmpty) return;

    await Navigator.of(context).pushNamed(AppRouter.weather, arguments: {'city': query});
    if (widget.onSearchCompleted != null) {
      await widget.onSearchCompleted!.call();
    }
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() => _loadingLocation = true);
    try {
      final position = await _locationService.getCurrentCoordinates();
      if (!mounted) return;
      await Navigator.of(context).pushNamed(
        AppRouter.weather,
        arguments: {
          'coords': {'lat': position.latitude, 'lon': position.longitude},
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to get location: $e')),
      );
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: AppStrings.searchCityHint,
              border: OutlineInputBorder(),
            ),
            onSubmitted: _performSearch,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 56,
          width: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
            ),
            onPressed: _loadingLocation ? null : _fetchCurrentLocation,
            child: _loadingLocation
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }
}
