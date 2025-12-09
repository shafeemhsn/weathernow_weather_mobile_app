import 'package:flutter/foundation.dart';

import '../domain/entities/forecast_day_entity.dart';
import '../domain/usecases/get_forecast_by_city.dart';

class ForecastViewModel extends ChangeNotifier {
  ForecastViewModel(this._useCase);

  final GetForecastByCity _useCase;

  List<ForecastDayEntity> forecast = <ForecastDayEntity>[];
  bool isLoading = false;
  String? errorMessage;

  Future<void> load(String city) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      forecast = await _useCase.call(city);
    } catch (e) {
      errorMessage = e.toString();
      forecast = <ForecastDayEntity>[];
    }
    isLoading = false;
    notifyListeners();
  }
}
