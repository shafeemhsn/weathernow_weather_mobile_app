import '../../domain/entities/forecast_day_entity.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/repository/weather_repository.dart';
import '../sources/weather_api_service.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl(this._service);

  final WeatherApiService _service;

  @override
  Future<WeatherEntity> getWeatherByCity(String city) {
    return _service.fetchWeatherByCity(city);
  }

  @override
  Future<WeatherEntity> getWeatherByCoords(String coords) {
    return _service.fetchWeatherByCoords(coords);
  }

  @override
  Future<List<ForecastDayEntity>> getForecastByCity(String city) {
    return _service.fetchForecastByCity(city);
  }
}
