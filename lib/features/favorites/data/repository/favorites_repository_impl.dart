import '../../domain/entities/favorite_city.dart';
import '../../domain/repository/favorites_repository.dart';
import '../models/favorite_city_model.dart';
import '../sources/favorites_local_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._source);

  final FavoritesLocalSource _source;

  @override
  Future<void> addFavorite(FavoriteCity city) async {
    await _source.add(FavoriteCityModel(name: city.name));
  }

  @override
  Future<List<FavoriteCity>> getFavorites({String query = ''}) {
    return _source.fetch(query: query);
  }

  @override
  Future<void> removeFavorite(FavoriteCity city) async {
    await _source.remove(FavoriteCityModel(name: city.name));
  }

  @override
  Future<bool> isFavorite(String city) {
    return _source.contains(city);
  }
}
