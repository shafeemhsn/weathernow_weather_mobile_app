import '../../domain/entities/favourite_city.dart';
import '../../domain/repository/favourites_repository.dart';
import '../models/favourite_city_model.dart';
import '../sources/favourites_local_source.dart';

class FavouritesRepositoryImpl implements FavouritesRepository {
  FavouritesRepositoryImpl(this._source);

  final FavouritesLocalSource _source;

  @override
  Future<void> addFavourite(FavouriteCity city) async {
    await _source.add(FavouriteCityModel(name: city.name));
  }

  @override
  Future<List<FavouriteCity>> getFavourites({String query = ''}) {
    return _source.fetch(query: query);
  }

  @override
  Future<void> removeFavourite(FavouriteCity city) async {
    await _source.remove(FavouriteCityModel(name: city.name));
  }

  @override
  Future<bool> isFavourite(String city) {
    return _source.contains(city);
  }
}
