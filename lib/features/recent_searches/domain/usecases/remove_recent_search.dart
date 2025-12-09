import '../repository/recent_searches_repository.dart';

class RemoveRecentSearch {
  RemoveRecentSearch(this._repository);

  final RecentSearchesRepository _repository;

  Future<void> call(String city) => _repository.removeRecentSearch(city);
}
