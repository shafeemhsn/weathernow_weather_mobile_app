import 'package:flutter/material.dart';

import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../widgets/dynamic_weather_icon.dart';
import '../widgets/metrics_grid.dart';
import '../widgets/temperature_section.dart';
import '../widgets/weather_header.dart';

class CurrentWeatherScreen extends StatelessWidget {
  final String? city;
  final String? coords;

  const CurrentWeatherScreen({super.key, this.city, this.coords});

  @override
  Widget build(BuildContext context) {
    final displayLocation = city ?? coords ?? 'Unknown';
    return Scaffold(
      appBar: AppBar(title: Text('Weather: ' + displayLocation)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            WeatherHeader(location: 'Current location'),
            SizedBox(height: 16),
            DynamicWeatherIcon(condition: 'sunny'),
            SizedBox(height: 16),
            TemperatureSection(temperature: 28, feelsLike: 30),
            SizedBox(height: 16),
            MetricsGrid(humidity: 60, windSpeed: 12, pressure: 1012),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushNamed('/');
          } else if (index == 2) {
            Navigator.of(context).pushNamed('/favorites');
          } else if (index == 3) {
            Navigator.of(context).pushNamed('/settings');
          }
        },
      ),
    );
  }
}
