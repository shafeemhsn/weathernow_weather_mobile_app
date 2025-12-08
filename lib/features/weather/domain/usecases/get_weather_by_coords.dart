import '../entities/weather_entity.dart';
import '../repository/weather_repository.dart';

class GetWeatherByCoords {
  GetWeatherByCoords(this._repository);

  final WeatherRepository _repository;

  Future<WeatherEntity> call(double lat, double lon) {
    return _repository.getWeatherByCoords(lat, lon);
  }
}
