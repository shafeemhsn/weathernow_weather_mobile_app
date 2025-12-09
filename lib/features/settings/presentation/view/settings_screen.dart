import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../router/app_router.dart';
import '../../../favorites/data/sources/favorites_local_source.dart';
import '../../../recent_searches/domain/usecases/clear_recent_searches.dart';
import '../widgets/about_section.dart';
import '../widgets/app_preferences_section.dart';
import '../widgets/data_management_section.dart';
import '../widgets/unit_toggle_section.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final FavoritesLocalSource _favoritesSource;

  @override
  void initState() {
    super.initState();
    _favoritesSource = ref.read(favoritesLocalSourceProvider);
    Future.microtask(() => ref.read(settingsViewModelProvider).load());
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(settingsViewModelProvider);
    final clearRecentSearches = ref.read(clearRecentSearchesProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Settings'),
      ),
      body: viewModel.settings == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                UnitToggleSection(
                  useFahrenheit: viewModel.settings!.temperatureUnit == 'F',
                  windUnit: viewModel.settings!.windUnit,
                  onTemperatureChanged: (value) =>
                      viewModel.updateTempUnit(value ? 'F' : 'C'),
                  onWindChanged: viewModel.updateWindUnit,
                ),
                const SizedBox(height: 12),
                AppPreferencesSection(
                  autoLocation: viewModel.settings!.autoLocation,
                  notifications: viewModel.settings!.notificationsEnabled,
                  onAutoLocationChanged: viewModel.updateAutoLocation,
                  onNotificationsChanged: viewModel.updateNotifications,
                ),
                const SizedBox(height: 12),
                DataManagementSection(
                  onClearFavorites: _clearFavorites,
                  onClearRecentSearches: () =>
                      _clearRecentSearchesHandler(clearRecentSearches),
                  onClearAll: () => _clearAllData(clearRecentSearches),
                ),
                const SizedBox(height: 12),
                const AboutSection(),
              ],
            ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed(AppRouter.home);
          } else if (index == 1) {
            Navigator.of(context).pushReplacementNamed(AppRouter.favorites);
          }
        },
      ),
    );
  }

  Future<void> _clearFavorites() async {
    await _favoritesSource.clear();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Favorites cleared')));
    }
  }

  Future<void> _clearRecentSearchesHandler(
    ClearRecentSearches clearRecentSearches,
  ) async {
    await clearRecentSearches.call();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Recent searches cleared')));
    }
  }

  Future<void> _clearAllData(ClearRecentSearches clearRecentSearches) async {
    final viewModel = ref.read(settingsViewModelProvider);
    await viewModel.clear();
    await _favoritesSource.clear();
    await clearRecentSearches.call();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All data cleared')));
    }
  }
}
