import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../database/dao/favourites_dao.dart';
import '../database/dao/settings_dao.dart';
import '../network/dio_client.dart';
import '../../features/favourites/favourites.dart';
import '../../features/recent_searches/recent_searches.dart';
import '../../features/settings/settings.dart';
import '../../features/weather/weather.dart';

// Core singletons / infrastructure
final appDatabaseProvider = Provider<AppDatabase>((_) => AppDatabase());
final favouritesDaoProvider = Provider<FavouritesDao>((ref) => FavouritesDao(ref.read(appDatabaseProvider)));
final settingsDaoProvider = Provider<SettingsDao>((ref) => SettingsDao(ref.read(appDatabaseProvider)));
final dioClientProvider = Provider<DioClient>((_) => DioClient());

// Data sources
final favouritesLocalSourceProvider = Provider<FavouritesLocalSource>((_) => FavouritesLocalSource());
final recentSearchesLocalSourceProvider =
    Provider<RecentSearchesLocalSource>((_) => RecentSearchesLocalSource());
final settingsLocalSourceProvider = Provider<SettingsLocalSource>((_) => SettingsLocalSource());
final weatherApiServiceProvider =
    Provider<WeatherApiService>((ref) => WeatherApiService(ref.read(dioClientProvider)));

// Repositories
final favouritesRepositoryProvider =
    Provider<FavouritesRepositoryImpl>((ref) => FavouritesRepositoryImpl(ref.read(favouritesLocalSourceProvider)));
final recentSearchesRepositoryProvider = Provider<RecentSearchesRepositoryImpl>(
    (ref) => RecentSearchesRepositoryImpl(ref.read(recentSearchesLocalSourceProvider)));
final settingsRepositoryProvider =
    Provider<SettingsRepositoryImpl>((ref) => SettingsRepositoryImpl(ref.read(settingsLocalSourceProvider)));
final weatherRepositoryProvider =
    Provider<WeatherRepositoryImpl>((ref) => WeatherRepositoryImpl(ref.read(weatherApiServiceProvider)));

// Use cases
final addRecentSearchProvider =
    Provider<AddRecentSearch>((ref) => AddRecentSearch(ref.read(recentSearchesRepositoryProvider)));
final clearRecentSearchesProvider =
    Provider<ClearRecentSearches>((ref) => ClearRecentSearches(ref.read(recentSearchesRepositoryProvider)));

// ViewModels (ChangeNotifier based)
final favouritesViewModelProvider = ChangeNotifierProvider.autoDispose<FavouritesViewModel>((ref) {
  final repo = ref.read(favouritesRepositoryProvider);
  return FavouritesViewModel(
    GetFavourites(repo),
    AddFavourite(repo),
    RemoveFavourite(repo),
    IsFavourite(repo),
  );
});

final recentSearchesViewModelProvider = ChangeNotifierProvider.autoDispose<RecentSearchesViewModel>((ref) {
  final repo = ref.read(recentSearchesRepositoryProvider);
  return RecentSearchesViewModel(
    GetRecentSearches(repo),
    ClearRecentSearches(repo),
    RemoveRecentSearch(repo),
  );
});

final settingsViewModelProvider = ChangeNotifierProvider.autoDispose<SettingsViewModel>((ref) {
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

final currentWeatherViewModelProvider = ChangeNotifierProvider.autoDispose<CurrentWeatherViewModel>((ref) {
  final repo = ref.read(weatherRepositoryProvider);
  return CurrentWeatherViewModel(
    GetWeatherByCity(repo),
    GetWeatherByCoords(repo),
  );
});

final forecastViewModelProvider = ChangeNotifierProvider.autoDispose<ForecastViewModel>((ref) {
  final repo = ref.read(weatherRepositoryProvider);
  return ForecastViewModel(
    GetForecastByCity(repo),
  );
});
