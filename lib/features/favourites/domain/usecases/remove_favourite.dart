import '../entities/favourite_city.dart';
import '../repository/favourites_repository.dart';

class RemoveFavourite {
  RemoveFavourite(this._repository);

  final FavouritesRepository _repository;

  Future<void> call(FavouriteCity city) => _repository.removeFavourite(city);
}
