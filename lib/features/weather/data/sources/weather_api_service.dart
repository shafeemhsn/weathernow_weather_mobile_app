import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/forecast_model.dart';
import '../models/weather_model.dart';

class WeatherApiService {
  WeatherApiService(this._client);

  final DioClient _client;

  Future<WeatherModel> fetchWeatherByCity(String city) async {
    final json = await _client.get(
      ApiConstants.currentWeatherPath,
      queryParameters: {ApiConstants.cityQuery: city},
    );
    return WeatherModel.fromJson(json);
  }

  Future<WeatherModel> fetchWeatherByCoords(double lat, double lon) async {
    final json = await _client.get(
      ApiConstants.currentWeatherPath,
      queryParameters: {
        ApiConstants.latQuery: lat,
        ApiConstants.lonQuery: lon,
      },
    );
    return WeatherModel.fromJson(json);
  }

  Future<List<ForecastModel>> fetchForecastByCity(String city) async {
    final json = await _client.get(
      ApiConstants.forecastPath,
      queryParameters: {ApiConstants.cityQuery: city},
    );
    final List<dynamic> items = json['list'] as List<dynamic>? ?? <dynamic>[];
    return items.map((item) => ForecastModel.fromJson(item as Map<String, dynamic>)).toList();
  }
}
