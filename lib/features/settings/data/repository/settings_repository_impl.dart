import '../../domain/entities/settings_entity.dart';
import '../../domain/repository/settings_repository.dart';
import '../models/settings_model.dart';
import '../sources/settings_local_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._source);

  final SettingsLocalSource _source;

  @override
  Future<void> clearAll() async {
    await _source.clear();
  }

  @override
  Future<SettingsEntity> getSettings() {
    return _source.fetch();
  }

  @override
  Future<void> update(SettingsEntity settings) {
    return _source.save(SettingsModel(
      temperatureUnit: settings.temperatureUnit,
      windUnit: settings.windUnit,
      autoLocation: settings.autoLocation,
    ));
  }
}
