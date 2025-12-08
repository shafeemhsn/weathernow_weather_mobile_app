import 'package:flutter/material.dart';

import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../router/app_router.dart';
import '../widgets/forecast_day_card.dart';

class ForecastScreen extends StatelessWidget {
  final String? city;

  const ForecastScreen({super.key, this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Forecast: ' + (city ?? 'Unknown')),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return const ForecastDayCard(
            dateLabel: 'Today',
            high: 30,
            low: 25,
            description: 'Sunny intervals',
          );
        },
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed(AppRouter.home);
          } else if (index == 2) {
            Navigator.of(context).pushReplacementNamed(AppRouter.favourites);
          } else if (index == 3) {
            Navigator.of(context).pushReplacementNamed(AppRouter.settings);
          }
        },
      ),
    );
  }
}
