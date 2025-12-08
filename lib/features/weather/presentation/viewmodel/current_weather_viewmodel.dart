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

  Future<void> loadByCity(String city) async {
    isLoading = true;
    notifyListeners();
    weather = await _byCity.call(city);
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadByCoords(String coords) async {
    isLoading = true;
    notifyListeners();
    weather = await _byCoords.call(coords);
    isLoading = false;
    notifyListeners();
  }
}
