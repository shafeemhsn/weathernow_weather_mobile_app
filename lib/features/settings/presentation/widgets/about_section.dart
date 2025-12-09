import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text(AppStrings.appName),
        subtitle: const Text('Version 1.0.0\nStay updated with live weather and forecasts.'),
        leading: const Icon(Icons.info_outline),
      ),
    );
  }
}
