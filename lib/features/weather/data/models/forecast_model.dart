import '../../domain/entities/forecast_day_entity.dart';

class ForecastModel extends ForecastDayEntity {
  const ForecastModel({
    required super.date,
    required super.tempMax,
    required super.tempMin,
    required super.description,
    required super.icon,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>?;
    final weatherList = json['weather'] as List<dynamic>? ?? <dynamic>[];
    final weather = weatherList.isNotEmpty ? weatherList.first as Map<String, dynamic>? : null;
    final rawDate = json['dt_txt'] as String? ?? json['date'] as String? ?? '';

    return ForecastModel(
      date: DateTime.tryParse(rawDate) ?? DateTime.now(),
      tempMax: (main?['temp_max'] ?? 0).toDouble(),
      tempMin: (main?['temp_min'] ?? 0).toDouble(),
      description: weather?['description'] as String? ?? '',
      icon: weather?['icon'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'temp_max': tempMax,
      'temp_min': tempMin,
      'description': description,
      'icon': icon,
    };
  }
}
