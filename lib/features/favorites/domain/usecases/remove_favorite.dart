import '../entities/favorite_city.dart';
import '../repository/favorites_repository.dart';

class RemoveFavorite {
  RemoveFavorite(this._repository);

  final FavoritesRepository _repository;

  Future<void> call(FavoriteCity city) => _repository.removeFavorite(city);
}
