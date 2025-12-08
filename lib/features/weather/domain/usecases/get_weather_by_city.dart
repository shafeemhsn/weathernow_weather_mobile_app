import '../entities/weather_entity.dart';
import '../repository/weather_repository.dart';

class GetWeatherByCity {
  GetWeatherByCity(this._repository);

  final WeatherRepository _repository;

  Future<WeatherEntity> call(String city) {
    return _repository.getWeatherByCity(city);
  }
}
