import '../../domain/entities/forecast_day_entity.dart';

class ForecastModel extends ForecastDayEntity {
  const ForecastModel({
    required super.date,
    required super.high,
    required super.low,
    required super.description,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      high: (json['high'] ?? 0).toDouble(),
      low: (json['low'] ?? 0).toDouble(),
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'high': high,
      'low': low,
      'description': description,
    };
  }
}
