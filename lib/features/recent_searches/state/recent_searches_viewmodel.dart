import 'package:flutter/foundation.dart';

import '../domain/entities/recent_search.dart';
import '../domain/usecases/clear_recent_searches.dart';
import '../domain/usecases/get_recent_searches.dart';
import '../domain/usecases/remove_recent_search.dart';

class RecentSearchesViewModel extends ChangeNotifier {
  RecentSearchesViewModel(this._getRecents, this._clearRecents, this._removeRecent);

  final GetRecentSearches _getRecents;
  final ClearRecentSearches _clearRecents;
  final RemoveRecentSearch _removeRecent;

  List<RecentSearch> recentSearches = <RecentSearch>[];

  Future<void> load() async {
    recentSearches = await _getRecents.call();
    notifyListeners();
  }

  Future<void> clear() async {
    await _clearRecents.call();
    await load();
  }

  Future<void> remove(String city) async {
    await _removeRecent.call(city);
    await load();
  }
}
