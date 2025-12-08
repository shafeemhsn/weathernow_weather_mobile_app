class SettingsEntity {
  final String temperatureUnit;
  final String windUnit;
  final bool autoLocation;
  final bool notificationsEnabled;

  const SettingsEntity({
    required this.temperatureUnit,
    required this.windUnit,
    required this.autoLocation,
    required this.notificationsEnabled,
  });
}
