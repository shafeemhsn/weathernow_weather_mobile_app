import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home), label: AppStrings.homeTitle),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite), label: AppStrings.favoritesTitle),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings), label: AppStrings.settingsTitle),
      ],
    );
  }
}
