import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../database/dao/favourites_dao.dart';
import '../database/dao/settings_dao.dart';
import '../network/dio_client.dart';
import '../../features/favourites/data/repository/favourites_repository_impl.dart';
import '../../features/favourites/data/sources/favourites_local_source.dart';
import '../../features/favourites/domain/usecases/add_favourite.dart';
import '../../features/favourites/domain/usecases/get_favourites.dart';
import '../../features/favourites/domain/usecases/is_favourite.dart';
import '../../features/favourites/domain/usecases/remove_favourite.dart';
import '../../features/favourites/presentation/viewmodel/favourites_viewmodel.dart';
import '../../features/recent_searches/data/repository/recent_searches_repository_impl.dart';
import '../../features/recent_searches/data/sources/recent_searches_local_source.dart';
import '../../features/recent_searches/domain/usecases/add_recent_search.dart';
import '../../features/recent_searches/domain/usecases/clear_recent_searches.dart';
import '../../features/recent_searches/domain/usecases/get_recent_searches.dart';
import '../../features/recent_searches/domain/usecases/remove_recent_search.dart';
import '../../features/recent_searches/presentation/viewmodel/recent_searches_viewmodel.dart';
import '../../features/settings/data/repository/settings_repository_impl.dart';
import '../../features/settings/data/sources/settings_local_source.dart';
import '../../features/settings/domain/usecases/clear_all_data.dart';
import '../../features/settings/domain/usecases/get_settings.dart';
import '../../features/settings/domain/usecases/update_auto_location.dart';
import '../../features/settings/domain/usecases/update_notifications.dart';
import '../../features/settings/domain/usecases/update_temperature_unit.dart';
import '../../features/settings/domain/usecases/update_wind_unit.dart';
import '../../features/settings/presentation/viewmodel/settings_viewmodel.dart';
import '../../features/weather/data/repository/weather_repository_impl.dart';
import '../../features/weather/data/sources/weather_api_service.dart';
import '../../features/weather/domain/usecases/get_weather_by_city.dart';
import '../../features/weather/domain/usecases/get_weather_by_coords.dart';
import '../../features/weather/presentation/viewmodel/current_weather_viewmodel.dart';
import '../../features/weather/domain/usecases/get_forecast_by_city.dart';
import '../../features/weather/presentation/viewmodel/forecast_viewmodel.dart';

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
