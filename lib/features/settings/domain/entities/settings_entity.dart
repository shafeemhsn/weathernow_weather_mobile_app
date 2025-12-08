class SettingsEntity {
  final String temperatureUnit;
  final String windUnit;
  final bool autoLocation;

  const SettingsEntity({
    required this.temperatureUnit,
    required this.windUnit,
    required this.autoLocation,
  });
}
