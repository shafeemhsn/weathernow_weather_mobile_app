import '../entities/settings_entity.dart';
import '../repository/settings_repository.dart';

class UpdateWindUnit {
  UpdateWindUnit(this._repository);

  final SettingsRepository _repository;

  Future<void> call(SettingsEntity settings, String unit) {
    return _repository.update(SettingsEntity(
      temperatureUnit: settings.temperatureUnit,
      windUnit: unit,
      autoLocation: settings.autoLocation,
    ));
  }
}
