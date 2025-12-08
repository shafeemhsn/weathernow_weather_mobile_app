import '../entities/favourite_city.dart';
import '../repository/favourites_repository.dart';

class GetFavourites {
  GetFavourites(this._repository);

  final FavouritesRepository _repository;

  Future<List<FavouriteCity>> call({String query = ''}) => _repository.getFavourites(query: query);
}
