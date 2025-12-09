import '../entities/favorite_city.dart';
import '../repository/favorites_repository.dart';

class GetFavorites {
  GetFavorites(this._repository);

  final FavoritesRepository _repository;

  Future<List<FavoriteCity>> call({String query = ''}) =>
      _repository.getFavorites(query: query);
}
