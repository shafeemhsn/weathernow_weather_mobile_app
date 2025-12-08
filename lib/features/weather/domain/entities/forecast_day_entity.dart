class ForecastDayEntity {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final String description;
  final String icon;

  const ForecastDayEntity({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.description,
    required this.icon,
  });
}
