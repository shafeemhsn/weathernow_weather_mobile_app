import '../repository/recent_searches_repository.dart';

class AddRecentSearch {
  AddRecentSearch(this._repository);

  final RecentSearchesRepository _repository;

  Future<void> call(String city) => _repository.addRecentSearch(city);
}
