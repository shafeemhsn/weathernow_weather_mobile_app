import '../../domain/entities/recent_search.dart';
import '../../domain/repository/recent_searches_repository.dart';
import '../models/recent_search_model.dart';
import '../sources/recent_searches_local_source.dart';

class RecentSearchesRepositoryImpl implements RecentSearchesRepository {
  RecentSearchesRepositoryImpl(this._source);

  final RecentSearchesLocalSource _source;

  @override
  Future<void> addRecentSearch(String city) {
    return _source.add(city);
  }

  @override
  Future<void> clearRecentSearches() {
    return _source.clear();
  }

  @override
  Future<void> removeRecentSearch(String city) {
    return _source.remove(city);
  }

  @override
  Future<List<RecentSearch>> getRecentSearches() async {
    final items = await _source.fetch();
    return items.map((name) => RecentSearchModel(name: name)).toList();
  }
}
