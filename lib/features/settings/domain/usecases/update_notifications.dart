import '../entities/settings_entity.dart';
import '../repository/settings_repository.dart';

class UpdateNotifications {
  UpdateNotifications(this._repository);

  final SettingsRepository _repository;

  Future<void> call(SettingsEntity settings, bool enabled) {
    return _repository.update(SettingsEntity(
      temperatureUnit: settings.temperatureUnit,
      windUnit: settings.windUnit,
      autoLocation: settings.autoLocation,
      notificationsEnabled: enabled,
    ));
  }
}
