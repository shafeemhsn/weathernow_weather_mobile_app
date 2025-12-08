import '../../domain/entities/favourite_city.dart';
import '../../domain/repository/favourites_repository.dart';
import '../models/favourite_city_model.dart';
import '../sources/favourites_local_source.dart';

class FavouritesRepositoryImpl implements FavouritesRepository {
  FavouritesRepositoryImpl(this._source);

  final FavouritesLocalSource _source;

  @override
  Future<void> addFavourite(FavouriteCity city) {
    return _source.add(FavouriteCityModel(name: city.name));
  }

  @override
  Future<List<FavouriteCity>> getFavourites() {
    return _source.fetch();
  }

  @override
  Future<void> removeFavourite(FavouriteCity city) {
    return _source.remove(FavouriteCityModel(name: city.name));
  }
}
