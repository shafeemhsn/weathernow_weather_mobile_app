class ForecastDayEntity {
  final DateTime date;
  final double high;
  final double low;
  final String description;

  const ForecastDayEntity({
    required this.date,
    required this.high,
    required this.low,
    required this.description,
  });
}
