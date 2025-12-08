import '../models/favourite_city_model.dart';

class FavouritesLocalSource {
  final List<FavouriteCityModel> _storage = <FavouriteCityModel>[];

  Future<List<FavouriteCityModel>> fetch() async {
    return List<FavouriteCityModel>.from(_storage);
  }

  Future<void> add(FavouriteCityModel city) async {
    _storage.add(city);
  }

  Future<void> remove(FavouriteCityModel city) async {
    _storage.removeWhere((item) => item.name == city.name);
  }
}
