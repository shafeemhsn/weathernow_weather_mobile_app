import 'package:flutter/material.dart';

class FavouriteWeatherCard extends StatelessWidget {
  final String city;
  final double temperature;

  const FavouriteWeatherCard({
    super.key,
    required this.city,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(city),
        trailing: Text('${temperature.toStringAsFixed(1)}?'),
      ),
    );
  }
}
