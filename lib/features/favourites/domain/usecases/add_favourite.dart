import '../entities/favourite_city.dart';
import '../repository/favourites_repository.dart';

class AddFavourite {
  AddFavourite(this._repository);

  final FavouritesRepository _repository;

  Future<void> call(FavouriteCity city) => _repository.addFavourite(city);
}
