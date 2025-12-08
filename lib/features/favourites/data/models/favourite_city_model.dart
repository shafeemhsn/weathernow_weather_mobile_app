import '../../domain/entities/favourite_city.dart';

class FavouriteCityModel extends FavouriteCity {
  const FavouriteCityModel({required super.name});

  factory FavouriteCityModel.fromJson(Map<String, dynamic> json) {
    return FavouriteCityModel(name: json['name'] as String? ?? '');
  }

  Map<String, dynamic> toJson() => {'name': name};
}
