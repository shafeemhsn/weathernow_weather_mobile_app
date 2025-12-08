import 'package:flutter/foundation.dart';

import '../../domain/entities/favourite_city.dart';
import '../../domain/usecases/add_favourite.dart';
import '../../domain/usecases/get_favourites.dart';
import '../../domain/usecases/remove_favourite.dart';

class FavouritesViewModel extends ChangeNotifier {
  FavouritesViewModel(this._get, this._add, this._remove);

  final GetFavourites _get;
  final AddFavourite _add;
  final RemoveFavourite _remove;

  List<FavouriteCity> favourites = <FavouriteCity>[];

  Future<void> load() async {
    favourites = await _get.call();
    notifyListeners();
  }

  Future<void> add(String city) async {
    await _add.call(FavouriteCity(name: city));
    await load();
  }

  Future<void> remove(String city) async {
    await _remove.call(FavouriteCity(name: city));
    await load();
  }
}
