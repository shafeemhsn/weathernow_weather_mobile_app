import '../../domain/entities/favorite_city.dart';

class FavoriteCityModel extends FavoriteCity {
  const FavoriteCityModel({required super.name});

  factory FavoriteCityModel.fromJson(Map<String, dynamic> json) {
    return FavoriteCityModel(name: json['name'] as String? ?? '');
  }

  Map<String, dynamic> toJson() => {'name': name};
}
