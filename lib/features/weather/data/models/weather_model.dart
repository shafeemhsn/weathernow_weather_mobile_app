import '../../domain/entities/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.cityName,
    required super.temperature,
    required super.description,
    required super.humidity,
    required super.windSpeed,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] as String? ?? '',
      temperature: (json['temp'] ?? 0).toDouble(),
      description: json['description'] as String? ?? '',
      humidity: (json['humidity'] ?? 0).toInt(),
      windSpeed: (json['wind_speed'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'temp': temperature,
      'description': description,
      'humidity': humidity,
      'wind_speed': windSpeed,
    };
  }
}
