import '../repository/favorites_repository.dart';

class IsFavorite {
  IsFavorite(this._repository);

  final FavoritesRepository _repository;

  Future<bool> call(String city) => _repository.isFavorite(city);
}
