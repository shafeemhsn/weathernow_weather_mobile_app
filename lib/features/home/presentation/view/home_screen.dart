import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/cities.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../widgets/city_search_bar.dart';
import '../widgets/navigation_cards_row.dart';
import '../widgets/quick_cities_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CitySearchBar(),
            SizedBox(height: 16),
            NavigationCardsRow(),
            SizedBox(height: 16),
            Text(AppStrings.quickCitiesTitle),
            SizedBox(height: 8),
            Expanded(child: QuickCitiesGrid(cities: quickCities)),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).pushNamed('/weather');
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
