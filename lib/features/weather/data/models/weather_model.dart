import '../../domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.cityName,
    required super.country,
    required super.temperature,
    required super.feelsLike,
    required super.description,
    required super.icon,
    required super.humidity,
    required super.windSpeed,
    required super.windDirection,
    required super.pressure,
    required super.visibility,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weatherList = json['weather'] as List<dynamic>? ?? <dynamic>[];
    final weather = weatherList.isNotEmpty ? weatherList.first as Map<String, dynamic>? : null;
    final main = json['main'] as Map<String, dynamic>?;
    final wind = json['wind'] as Map<String, dynamic>?;
    final sys = json['sys'] as Map<String, dynamic>?;

    return WeatherModel(
      cityName: json['name'] as String? ?? '',
      country: sys?['country'] as String? ?? '',
      temperature: (main?['temp'] ?? 0).toDouble(),
      feelsLike: (main?['feels_like'] ?? 0).toDouble(),
      description: weather?['description'] as String? ?? '',
      icon: weather?['icon'] as String? ?? '',
      humidity: (main?['humidity'] ?? 0).toInt(),
      windSpeed: (wind?['speed'] ?? 0).toDouble(),
      windDirection: (wind?['deg'] ?? 0).toInt(),
      pressure: (main?['pressure'] ?? 0).toInt(),
      visibility: (json['visibility'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'country': country,
      'temp': temperature,
      'feels_like': feelsLike,
      'description': description,
      'icon': icon,
      'humidity': humidity,
      'wind_speed': windSpeed,
      'wind_direction': windDirection,
      'pressure': pressure,
      'visibility': visibility,
    };
  }
}
