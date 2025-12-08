import 'package:flutter/material.dart';

class AppPreferencesSection extends StatelessWidget {
  const AppPreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Auto-detect location'),
            value: true,
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }
}
