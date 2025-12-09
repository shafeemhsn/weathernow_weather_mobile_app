import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../router/app_router.dart';

class CitySearchBar extends StatelessWidget {
  final Future<void> Function()? onSearchCompleted;

  const CitySearchBar({super.key, this.onSearchCompleted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: AppStrings.searchCityHint,
        border: OutlineInputBorder(),
      ),
      onSubmitted: (value) async {
        if (value.isNotEmpty) {
          await Navigator.of(context).pushNamed(AppRouter.weather, arguments: {'city': value});
          if (onSearchCompleted != null) {
            await onSearchCompleted!.call();
          }
        }
      },
    );
  }
}
