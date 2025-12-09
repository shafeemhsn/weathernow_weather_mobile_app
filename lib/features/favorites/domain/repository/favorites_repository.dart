import '../entities/favorite_city.dart';

abstract class FavoritesRepository {
  Future<List<FavoriteCity>> getFavorites({String query = ''});
  Future<void> addFavorite(FavoriteCity city);
  Future<void> removeFavorite(FavoriteCity city);
  Future<bool> isFavorite(String city);
}
