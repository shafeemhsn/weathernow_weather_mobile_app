import 'package:flutter/material.dart';

import '../features/favorites/presentation/view/favorites_screen.dart';
import '../features/home/presentation/view/home_screen.dart';
import '../features/settings/presentation/view/settings_screen.dart';
import '../features/weather/presentation/view/current_weather_screen.dart';
import '../features/weather/presentation/view/forecast_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String weather = '/weather';
  static const String forecast = '/forecast';
  static const String favorites = '/favorites';
  static const String settings = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case weather:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CurrentWeatherScreen(
            city: args?["city"] as String?,
            coords: args?["coords"],
          ),
        );
      case forecast:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ForecastScreen(city: args?["city"] as String?),
        );
      case favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
