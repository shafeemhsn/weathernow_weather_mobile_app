import 'package:shared_preferences/shared_preferences.dart';

import '../models/favourite_city_model.dart';

class FavouritesLocalSource {
  FavouritesLocalSource([SharedPreferences? prefs])
      : _prefsFuture = prefs != null ? Future.value(prefs) : SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefsFuture;
  static const String _storageKey = 'favourite_cities';

  Future<List<FavouriteCityModel>> fetch({String query = ''}) async {
    final prefs = await _prefsFuture;
    final stored = prefs.getStringList(_storageKey) ?? <String>[];
    final filtered = query.isEmpty
        ? stored
        : stored.where((name) => name.toLowerCase().contains(query.toLowerCase())).toList();
    return filtered.map((name) => FavouriteCityModel(name: name)).toList();
  }

  Future<void> add(FavouriteCityModel city) async {
    final prefs = await _prefsFuture;
    final stored = prefs.getStringList(_storageKey) ?? <String>[];
    final exists = stored.any((name) => name.toLowerCase() == city.name.toLowerCase());
    if (!exists) {
      stored.add(city.name);
      await prefs.setStringList(_storageKey, stored);
    }
  }

  Future<void> remove(FavouriteCityModel city) async {
    final prefs = await _prefsFuture;
    final stored = prefs.getStringList(_storageKey) ?? <String>[];
    stored.removeWhere((name) => name.toLowerCase() == city.name.toLowerCase());
    await prefs.setStringList(_storageKey, stored);
  }

  Future<bool> contains(String city) async {
    final prefs = await _prefsFuture;
    final stored = prefs.getStringList(_storageKey) ?? <String>[];
    return stored.any((name) => name.toLowerCase() == city.toLowerCase());
  }

  Future<void> clear() async {
    final prefs = await _prefsFuture;
    await prefs.remove(_storageKey);
  }
}
