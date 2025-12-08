import '../entities/settings_entity.dart';

abstract class SettingsRepository {
  Future<SettingsEntity> getSettings();
  Future<void> update(SettingsEntity settings);
  Future<void> clearAll();
}
