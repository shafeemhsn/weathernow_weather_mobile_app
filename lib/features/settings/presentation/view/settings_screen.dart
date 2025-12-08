import 'package:flutter/material.dart';

import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../router/app_router.dart';
import '../widgets/app_preferences_section.dart';
import '../widgets/data_management_section.dart';
import '../widgets/unit_toggle_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          UnitToggleSection(),
          SizedBox(height: 12),
          AppPreferencesSection(),
          SizedBox(height: 12),
          DataManagementSection(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacementNamed(AppRouter.home);
          } else if (index == 1) {
            Navigator.of(context).pushReplacementNamed(AppRouter.weather);
          } else if (index == 2) {
            Navigator.of(context).pushReplacementNamed(AppRouter.favourites);
          }
        },
      ),
    );
  }
}
