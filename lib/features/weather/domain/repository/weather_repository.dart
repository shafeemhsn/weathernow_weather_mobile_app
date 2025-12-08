import '../entities/forecast_day_entity.dart';
import '../entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<WeatherEntity> getWeatherByCity(String city);
  Future<WeatherEntity> getWeatherByCoords(double lat, double lon);
  Future<List<ForecastDayEntity>> getForecastByCity(String city);
}
