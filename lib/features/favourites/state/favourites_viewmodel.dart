import 'package:flutter/foundation.dart';

import '../domain/entities/favourite_city.dart';
import '../domain/usecases/add_favourite.dart';
import '../domain/usecases/get_favourites.dart';
import '../domain/usecases/is_favourite.dart';
import '../domain/usecases/remove_favourite.dart';

class FavouritesViewModel extends ChangeNotifier {
  FavouritesViewModel(this._get, this._add, this._remove, this._isFavourite);

  final GetFavourites _get;
  final AddFavourite _add;
  final RemoveFavourite _remove;
  final IsFavourite _isFavourite;

  List<FavouriteCity> favourites = <FavouriteCity>[];
  String searchQuery = '';

  Future<void> load({String query = ''}) async {
    searchQuery = query;
    favourites = await _get.call(query: query);
    notifyListeners();
  }

  Future<void> add(String city) async {
    await _add.call(FavouriteCity(name: city));
    await load(query: searchQuery);
  }

  Future<void> remove(String city) async {
    await _remove.call(FavouriteCity(name: city));
    await load(query: searchQuery);
  }

  Future<void> filter(String query) async {
    await load(query: query);
  }

  Future<bool> isFavourite(String city) {
    return _isFavourite.call(city);
  }
}
