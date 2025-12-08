class WeatherEntity {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;

  const WeatherEntity({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });
}
