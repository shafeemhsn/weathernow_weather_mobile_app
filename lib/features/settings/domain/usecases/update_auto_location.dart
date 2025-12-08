import '../entities/settings_entity.dart';
import '../repository/settings_repository.dart';

class UpdateAutoLocation {
  UpdateAutoLocation(this._repository);

  final SettingsRepository _repository;

  Future<void> call(SettingsEntity settings, bool autoLocation) {
    return _repository.update(SettingsEntity(
      temperatureUnit: settings.temperatureUnit,
      windUnit: settings.windUnit,
      autoLocation: autoLocation,
    ));
  }
}
