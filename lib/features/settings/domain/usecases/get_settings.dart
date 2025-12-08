import '../entities/settings_entity.dart';
import '../repository/settings_repository.dart';

class GetSettings {
  GetSettings(this._repository);

  final SettingsRepository _repository;

  Future<SettingsEntity> call() => _repository.getSettings();
}
