import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../router/app_router.dart';

class CitySearchBar extends StatelessWidget {
  const CitySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: AppStrings.searchCityHint,
        border: OutlineInputBorder(),
      ),
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          Navigator.of(context).pushNamed(AppRouter.weather, arguments: {'city': value});
        }
      },
    );
  }
}
