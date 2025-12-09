import '../entities/recent_search.dart';

abstract class RecentSearchesRepository {
  Future<List<RecentSearch>> getRecentSearches();

  Future<void> addRecentSearch(String city);

  Future<void> removeRecentSearch(String city);

  Future<void> clearRecentSearches();
}
