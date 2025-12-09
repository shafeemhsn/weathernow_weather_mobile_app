import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../database/dao/favorites_dao.dart';
import '../database/dao/settings_dao.dart';
import '../network/dio_client.dart';
import '../../features/favorites/favorites.dart';
import '../../features/recent_searches/recent_searches.dart';
import '../../features/settings/settings.dart';
import '../../features/weather/weather.dart';

// Core singletons / infrastructure
final appDatabaseProvider = Provider<AppDatabase>((_) => AppDatabase());
final favoritesDaoProvider = Provider<FavoritesDao>(
  (ref) => FavoritesDao(ref.read(appDatabaseProvider)),
);
final settingsDaoProvider = Provider<SettingsDao>(
  (ref) => SettingsDao(ref.read(appDatabaseProvider)),
);
final dioClientProvider = Provider<DioClient>((_) => DioClient());

// Data sources
final favoritesLocalSourceProvider = Provider<FavoritesLocalSource>(
  (_) => FavoritesLocalSource(),
);
final recentSearchesLocalSourceProvider = Provider<RecentSearchesLocalSource>(
  (_) => RecentSearchesLocalSource(),
);
final settingsLocalSourceProvider = Provider<SettingsLocalSource>(
  (_) => SettingsLocalSource(),
);
final weatherApiServiceProvider = Provider<WeatherApiService>(
  (ref) => WeatherApiService(ref.read(dioClientProvider)),
);

// Repositories
final favoritesRepositoryProvider = Provider<FavoritesRepositoryImpl>(
  (ref) => FavoritesRepositoryImpl(ref.read(favoritesLocalSourceProvider)),
);
final recentSearchesRepositoryProvider = Provider<RecentSearchesRepositoryImpl>(
  (ref) =>
      RecentSearchesRepositoryImpl(ref.read(recentSearchesLocalSourceProvider)),
);
final settingsRepositoryProvider = Provider<SettingsRepositoryImpl>(
  (ref) => SettingsRepositoryImpl(ref.read(settingsLocalSourceProvider)),
);
final weatherRepositoryProvider = Provider<WeatherRepositoryImpl>(
  (ref) => WeatherRepositoryImpl(ref.read(weatherApiServiceProvider)),
);

// Use cases
final addRecentSearchProvider = Provider<AddRecentSearch>(
  (ref) => AddRecentSearch(ref.read(recentSearchesRepositoryProvider)),
);
final clearRecentSearchesProvider = Provider<ClearRecentSearches>(
  (ref) => ClearRecentSearches(ref.read(recentSearchesRepositoryProvider)),
);

// ViewModels (ChangeNotifier based)
final favoritesViewModelProvider =
    ChangeNotifierProvider.autoDispose<FavoritesViewModel>((ref) {
      final repo = ref.read(favoritesRepositoryProvider);
      return FavoritesViewModel(
        GetFavorites(repo),
        AddFavorite(repo),
        RemoveFavorite(repo),
        IsFavorite(repo),
      );
    });

final recentSearchesViewModelProvider =
    ChangeNotifierProvider.autoDispose<RecentSearchesViewModel>((ref) {
      final repo = ref.read(recentSearchesRepositoryProvider);
      return RecentSearchesViewModel(
        GetRecentSearches(repo),
        ClearRecentSearches(repo),
        RemoveRecentSearch(repo),
      );
    });

final settingsViewModelProvider =
    ChangeNotifierProvider.autoDispose<SettingsViewModel>((ref) {
      final repo = ref.read(settingsRepositoryProvider);
      return SettingsViewModel(
        GetSettings(repo),
        UpdateTemperatureUnit(repo),
        UpdateWindUnit(repo),
        UpdateAutoLocation(repo),
        UpdateNotifications(repo),
        ClearAllData(repo),
      );
    });

final currentWeatherViewModelProvider =
    ChangeNotifierProvider.autoDispose<CurrentWeatherViewModel>((ref) {
      final repo = ref.read(weatherRepositoryProvider);
      return CurrentWeatherViewModel(
        GetWeatherByCity(repo),
        GetWeatherByCoords(repo),
      );
    });

final forecastViewModelProvider =
    ChangeNotifierProvider.autoDispose<ForecastViewModel>((ref) {
      final repo = ref.read(weatherRepositoryProvider);
      return ForecastViewModel(GetForecastByCity(repo));
    });
