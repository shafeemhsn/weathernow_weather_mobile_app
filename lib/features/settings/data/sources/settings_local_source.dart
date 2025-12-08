import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings_model.dart';

class SettingsLocalSource {
  SettingsLocalSource([SharedPreferences? prefs])
      : _prefsFuture = prefs != null ? Future.value(prefs) : SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefsFuture;

  static const String _tempKey = 'settings_temperature_unit';
  static const String _windKey = 'settings_wind_unit';
  static const String _autoLocationKey = 'settings_auto_location';
  static const String _notificationsKey = 'settings_notifications';

  Future<SettingsModel> fetch() async {
    final prefs = await _prefsFuture;
    return SettingsModel(
      temperatureUnit: prefs.getString(_tempKey) ?? 'C',
      windUnit: prefs.getString(_windKey) ?? 'km/h',
      autoLocation: prefs.getBool(_autoLocationKey) ?? true,
      notificationsEnabled: prefs.getBool(_notificationsKey) ?? true,
    );
  }

  Future<void> save(SettingsModel model) async {
    final prefs = await _prefsFuture;
    await prefs.setString(_tempKey, model.temperatureUnit);
    await prefs.setString(_windKey, model.windUnit);
    await prefs.setBool(_autoLocationKey, model.autoLocation);
    await prefs.setBool(_notificationsKey, model.notificationsEnabled);
  }

  Future<void> clear() async {
    final prefs = await _prefsFuture;
    await prefs.remove(_tempKey);
    await prefs.remove(_windKey);
    await prefs.remove(_autoLocationKey);
    await prefs.remove(_notificationsKey);
  }
}
