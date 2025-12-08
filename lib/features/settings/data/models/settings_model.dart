import '../../domain/entities/settings_entity.dart';

class SettingsModel extends SettingsEntity {
  const SettingsModel({
    required super.temperatureUnit,
    required super.windUnit,
    required super.autoLocation,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      temperatureUnit: json['temperatureUnit'] as String? ?? 'C',
      windUnit: json['windUnit'] as String? ?? 'km/h',
      autoLocation: json['autoLocation'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperatureUnit': temperatureUnit,
      'windUnit': windUnit,
      'autoLocation': autoLocation,
    };
  }
}
