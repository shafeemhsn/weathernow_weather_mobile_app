import '../entities/forecast_day_entity.dart';
import '../repository/weather_repository.dart';

class GetForecastByCity {
  GetForecastByCity(this._repository);

  final WeatherRepository _repository;

  Future<List<ForecastDayEntity>> call(String city) {
    return _repository.getForecastByCity(city);
  }
}
