import 'package:flutter/foundation.dart';

import '../../domain/entities/settings_entity.dart';
import '../../domain/usecases/clear_all_data.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/update_auto_location.dart';
import '../../domain/usecases/update_notifications.dart';
import '../../domain/usecases/update_temperature_unit.dart';
import '../../domain/usecases/update_wind_unit.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel(
    this._get,
    this._updateTemp,
    this._updateWind,
    this._updateAuto,
    this._updateNotifications,
    this._clear,
  );

  final GetSettings _get;
  final UpdateTemperatureUnit _updateTemp;
  final UpdateWindUnit _updateWind;
  final UpdateAutoLocation _updateAuto;
  final UpdateNotifications _updateNotifications;
  final ClearAllData _clear;

  SettingsEntity? settings;

  Future<void> load() async {
    settings = await _get.call();
    notifyListeners();
  }

  Future<void> updateTempUnit(String unit) async {
    if (settings == null) return;
    await _updateTemp.call(settings!, unit);
    await load();
  }

  Future<void> updateWindUnit(String unit) async {
    if (settings == null) return;
    await _updateWind.call(settings!, unit);
    await load();
  }

  Future<void> updateAutoLocation(bool auto) async {
    if (settings == null) return;
    await _updateAuto.call(settings!, auto);
    await load();
  }

  Future<void> updateNotifications(bool enabled) async {
    if (settings == null) return;
    await _updateNotifications.call(settings!, enabled);
    await load();
  }

  Future<void> clear() async {
    await _clear.call();
    await load();
  }
}
