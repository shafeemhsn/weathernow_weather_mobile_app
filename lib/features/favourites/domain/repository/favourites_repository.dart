import '../entities/favourite_city.dart';

abstract class FavouritesRepository {
  Future<List<FavouriteCity>> getFavourites({String query = ''});
  Future<void> addFavourite(FavouriteCity city);
  Future<void> removeFavourite(FavouriteCity city);
  Future<bool> isFavourite(String city);
}
