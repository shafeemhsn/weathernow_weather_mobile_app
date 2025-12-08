import '../entities/favourite_city.dart';

abstract class FavouritesRepository {
  Future<List<FavouriteCity>> getFavourites();
  Future<void> addFavourite(FavouriteCity city);
  Future<void> removeFavourite(FavouriteCity city);
}
