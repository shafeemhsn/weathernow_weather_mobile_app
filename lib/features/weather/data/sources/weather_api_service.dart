import '../../../../config/env.dart';
import '../../../../core/network/dio_client.dart';
import '../models/forecast_model.dart';
import '../models/weather_model.dart';

class WeatherApiService {
  WeatherApiService(this._client);

  final DioClient _client;

  Future<WeatherModel> fetchWeatherByCity(String city) async {
    final json = await _client.get('/weather', queryParameters: {'q': city, 'appid': Env.apiKey});
    return WeatherModel.fromJson(json);
  }

  Future<WeatherModel> fetchWeatherByCoords(String coords) async {
    final json = await _client.get('/weather', queryParameters: {'latlon': coords, 'appid': Env.apiKey});
    return WeatherModel.fromJson(json);
  }

  Future<List<ForecastModel>> fetchForecastByCity(String city) async {
    final json = await _client.get('/forecast', queryParameters: {'q': city, 'appid': Env.apiKey});
    final List<dynamic> items = json['list'] as List<dynamic>? ?? <dynamic>[];
    return items.map((item) => ForecastModel.fromJson(item as Map<String, dynamic>)).toList();
  }
}
