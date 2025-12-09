import '../repository/recent_searches_repository.dart';

class ClearRecentSearches {
  ClearRecentSearches(this._repository);

  final RecentSearchesRepository _repository;

  Future<void> call() => _repository.clearRecentSearches();
}
