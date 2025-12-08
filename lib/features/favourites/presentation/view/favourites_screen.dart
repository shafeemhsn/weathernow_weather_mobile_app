import 'package:flutter/material.dart';

import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../router/app_router.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Favorites'),
      ),
      body: const Center(
        child: Text('Your favourite cities will appear here.'),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed(AppRouter.home);
          } else if (index == 1) {
            Navigator.of(context).pushReplacementNamed(AppRouter.weather);
          } else if (index == 3) {
            Navigator.of(context).pushReplacementNamed(AppRouter.settings);
          }
        },
      ),
    );
  }
}
