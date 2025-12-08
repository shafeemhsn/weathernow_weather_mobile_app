import '../repository/settings_repository.dart';

class ClearAllData {
  ClearAllData(this._repository);

  final SettingsRepository _repository;

  Future<void> call() => _repository.clearAll();
}
