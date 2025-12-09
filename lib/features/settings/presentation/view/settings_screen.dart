import 'package:flutter/material.dart';

import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../router/app_router.dart';
import '../../../favourites/data/sources/favourites_local_source.dart';
import '../../data/repository/settings_repository_impl.dart';
import '../../data/sources/settings_local_source.dart';
import '../../domain/usecases/clear_all_data.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/update_auto_location.dart';
import '../../domain/usecases/update_notifications.dart';
import '../../domain/usecases/update_temperature_unit.dart';
import '../../domain/usecases/update_wind_unit.dart';
import '../viewmodel/settings_viewmodel.dart';
import '../widgets/about_section.dart';
import '../widgets/app_preferences_section.dart';
import '../widgets/data_management_section.dart';
import '../widgets/unit_toggle_section.dart';
import '../../../recent_searches/data/repository/recent_searches_repository_impl.dart';
import '../../../recent_searches/data/sources/recent_searches_local_source.dart';
import '../../../recent_searches/domain/usecases/clear_recent_searches.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsViewModel _viewModel;
  final _favouritesSource = FavouritesLocalSource();
  late final ClearRecentSearches _clearRecentSearches;

  @override
  void initState() {
    super.initState();
    final repository = SettingsRepositoryImpl(SettingsLocalSource());
    _viewModel = SettingsViewModel(
      GetSettings(repository),
      UpdateTemperatureUnit(repository),
      UpdateWindUnit(repository),
      UpdateAutoLocation(repository),
      UpdateNotifications(repository),
      ClearAllData(repository),
    );
    final recentsRepo = RecentSearchesRepositoryImpl(RecentSearchesLocalSource());
    _clearRecentSearches = ClearRecentSearches(recentsRepo);
    _viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Settings'),
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          final settings = _viewModel.settings;
          if (settings == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              UnitToggleSection(
                useFahrenheit: settings.temperatureUnit == 'F',
                windUnit: settings.windUnit,
                onTemperatureChanged: (value) =>
                    _viewModel.updateTempUnit(value ? 'F' : 'C'),
                onWindChanged: _viewModel.updateWindUnit,
              ),
              const SizedBox(height: 12),
              AppPreferencesSection(
                autoLocation: settings.autoLocation,
                notifications: settings.notificationsEnabled,
                onAutoLocationChanged: _viewModel.updateAutoLocation,
                onNotificationsChanged: _viewModel.updateNotifications,
              ),
              const SizedBox(height: 12),
              DataManagementSection(
                onClearFavorites: _clearFavorites,
                onClearRecentSearches: _clearRecentSearchesHandler,
                onClearAll: _clearAllData,
              ),
              const SizedBox(height: 12),
              const AboutSection(),
            ],
          );
        },
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed(AppRouter.home);
          } else if (index == 1) {
            Navigator.of(context).pushReplacementNamed(AppRouter.weather);
          } else if (index == 2) {
            Navigator.of(context).pushReplacementNamed(AppRouter.forecast);
          } else if (index == 3) {
            Navigator.of(context).pushReplacementNamed(AppRouter.favourites);
          }
        },
      ),
    );
  }

  Future<void> _clearFavorites() async {
    await _favouritesSource.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Favorites cleared')),
      );
    }
  }

  Future<void> _clearRecentSearchesHandler() async {
    await _clearRecentSearches.call();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recent searches cleared')),
      );
    }
  }

  Future<void> _clearAllData() async {
    await _viewModel.clear();
    await _favouritesSource.clear();
    await _clearRecentSearches.call();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All data cleared')),
      );
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
