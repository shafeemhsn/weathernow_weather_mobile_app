import 'package:flutter/material.dart';

class WeatherHeader extends StatelessWidget {
  final String location;

  const WeatherHeader({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Text(location, style: Theme.of(context).textTheme.headlineMedium);
  }
}
