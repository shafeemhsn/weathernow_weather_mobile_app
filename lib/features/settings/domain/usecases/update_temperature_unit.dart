import '../entities/settings_entity.dart';
import '../repository/settings_repository.dart';

class UpdateTemperatureUnit {
  UpdateTemperatureUnit(this._repository);

  final SettingsRepository _repository;

  Future<void> call(SettingsEntity settings, String unit) {
    return _repository.update(SettingsEntity(
      temperatureUnit: unit,
      windUnit: settings.windUnit,
      autoLocation: settings.autoLocation,
      notificationsEnabled: settings.notificationsEnabled,
    ));
  }
}
