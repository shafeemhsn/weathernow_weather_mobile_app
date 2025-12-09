import 'package:flutter/foundation.dart';

import '../domain/entities/favorite_city.dart';
import '../domain/usecases/add_favorite.dart';
import '../domain/usecases/get_favorites.dart';
import '../domain/usecases/is_favorite.dart';
import '../domain/usecases/remove_favorite.dart';

class FavoritesViewModel extends ChangeNotifier {
  FavoritesViewModel(this._get, this._add, this._remove, this._isFavorite);

  final GetFavorites _get;
  final AddFavorite _add;
  final RemoveFavorite _remove;
  final IsFavorite _isFavorite;

  List<FavoriteCity> favorites = <FavoriteCity>[];
  String searchQuery = '';

  Future<void> load({String query = ''}) async {
    searchQuery = query;
    favorites = await _get.call(query: query);
    notifyListeners();
  }

  Future<void> add(String city) async {
    await _add.call(FavoriteCity(name: city));
    await load(query: searchQuery);
  }

  Future<void> remove(String city) async {
    await _remove.call(FavoriteCity(name: city));
    await load(query: searchQuery);
  }

  Future<void> filter(String query) async {
    await load(query: query);
  }

  Future<bool> isFavorite(String city) {
    return _isFavorite.call(city);
  }
}
