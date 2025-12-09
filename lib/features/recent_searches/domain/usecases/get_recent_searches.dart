import '../entities/recent_search.dart';
import '../repository/recent_searches_repository.dart';

class GetRecentSearches {
  GetRecentSearches(this._repository);

  final RecentSearchesRepository _repository;

  Future<List<RecentSearch>> call() => _repository.getRecentSearches();
}
