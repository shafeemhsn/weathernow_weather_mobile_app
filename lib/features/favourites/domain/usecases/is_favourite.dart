import '../repository/favourites_repository.dart';

class IsFavourite {
  IsFavourite(this._repository);

  final FavouritesRepository _repository;

  Future<bool> call(String city) => _repository.isFavourite(city);
}
