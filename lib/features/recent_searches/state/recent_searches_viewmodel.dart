import 'package:flutter/foundation.dart';

import '../domain/entities/recent_search.dart';
import '../domain/usecases/clear_recent_searches.dart';
import '../domain/usecases/get_recent_searches.dart';
import '../domain/usecases/remove_recent_search.dart';

class RecentSearchesViewModel extends ChangeNotifier {
  RecentSearchesViewModel(
    this._getRecent,
    this._clearRecent,
    this._removeRecent,
  );

  final GetRecentSearches _getRecent;
  final ClearRecentSearches _clearRecent;
  final RemoveRecentSearch _removeRecent;

  List<RecentSearch> recentSearches = <RecentSearch>[];

  Future<void> load() async {
    recentSearches = await _getRecent.call();
    notifyListeners();
  }

  Future<void> clear() async {
    await _clearRecent.call();
    await load();
  }

  Future<void> remove(String city) async {
    await _removeRecent.call(city);
    await load();
  }
}
