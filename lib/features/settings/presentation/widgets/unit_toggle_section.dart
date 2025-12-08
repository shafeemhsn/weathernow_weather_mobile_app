import 'package:flutter/material.dart';

class UnitToggleSection extends StatelessWidget {
  const UnitToggleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Use Fahrenheit'),
            value: false,
            onChanged: (_) {},
          ),
          SwitchListTile(
            title: const Text('Use mph'),
            value: false,
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }
}
