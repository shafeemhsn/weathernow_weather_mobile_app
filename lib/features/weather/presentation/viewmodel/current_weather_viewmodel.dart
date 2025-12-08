import 'package:flutter/foundation.dart';

import '../../domain/entities/weather_entity.dart';
import '../../domain/usecases/get_weather_by_city.dart';
import '../../domain/usecases/get_weather_by_coords.dart';

class CurrentWeatherViewModel extends ChangeNotifier {
  CurrentWeatherViewModel(this._byCity, this._byCoords);

  final GetWeatherByCity _byCity;
  final GetWeatherByCoords _byCoords;

  WeatherEntity? weather;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadByCity(String city) async {
    await _load(() => _byCity.call(city));
  }

  Future<void> loadByCoords(double lat, double lon) async {
    await _load(() => _byCoords.call(lat, lon));
  }

  Future<void> _load(Future<WeatherEntity> Function() loader) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      weather = await loader();
    } catch (e) {
      errorMessage = e.toString();
      weather = null;
    }
    isLoading = false;
    notifyListeners();
  }
}
