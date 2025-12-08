import '../models/settings_model.dart';

class SettingsLocalSource {
  SettingsModel _settings = const SettingsModel(
    temperatureUnit: 'C',
    windUnit: 'km/h',
    autoLocation: true,
  );

  Future<SettingsModel> fetch() async {
    return _settings;
  }

  Future<void> save(SettingsModel model) async {
    _settings = model;
  }
}
