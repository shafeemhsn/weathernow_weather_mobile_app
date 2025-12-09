import 'package:shared_preferences/shared_preferences.dart';

class RecentSearchesLocalSource {
  RecentSearchesLocalSource([SharedPreferences? prefs])
      : _prefsFuture = prefs != null ? Future.value(prefs) : SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefsFuture;

  static const String _storageKey = 'recent_searches';
  static const int _maxItems = 10;

  Future<List<String>> fetch() async {
    final prefs = await _prefsFuture;
    return prefs.getStringList(_storageKey) ?? <String>[];
  }

  Future<void> add(String city) async {
    final prefs = await _prefsFuture;
    final stored = List<String>.from(prefs.getStringList(_storageKey) ?? <String>[]);
    stored.removeWhere((name) => name.toLowerCase() == city.toLowerCase());
    stored.insert(0, city);
    if (stored.length > _maxItems) {
      stored.removeRange(_maxItems, stored.length);
    }
    await prefs.setStringList(_storageKey, stored);
  }

  Future<void> clear() async {
    final prefs = await _prefsFuture;
    await prefs.remove(_storageKey);
  }

  Future<void> remove(String city) async {
    final prefs = await _prefsFuture;
    final stored = List<String>.from(prefs.getStringList(_storageKey) ?? <String>[]);
    stored.removeWhere((name) => name.toLowerCase() == city.toLowerCase());
    await prefs.setStringList(_storageKey, stored);
  }
}
