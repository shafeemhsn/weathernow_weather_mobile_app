import '../entities/favorite_city.dart';
import '../repository/favorites_repository.dart';

class AddFavorite {
  AddFavorite(this._repository);

  final FavoritesRepository _repository;

  Future<void> call(FavoriteCity city) => _repository.addFavorite(city);
}
