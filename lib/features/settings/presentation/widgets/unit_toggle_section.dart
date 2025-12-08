import 'package:flutter/material.dart';

class UnitToggleSection extends StatelessWidget {
  final bool useFahrenheit;
  final String windUnit;
  final ValueChanged<bool> onTemperatureChanged;
  final ValueChanged<String> onWindChanged;

  const UnitToggleSection({
    super.key,
    required this.useFahrenheit,
    required this.windUnit,
    required this.onTemperatureChanged,
    required this.onWindChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Use Fahrenheit'),
            value: useFahrenheit,
            onChanged: onTemperatureChanged,
          ),
          ListTile(
            title: const Text('Wind speed unit'),
            trailing: DropdownButton<String>(
              value: windUnit,
              onChanged: (value) {
                if (value != null) onWindChanged(value);
              },
              items: const [
                DropdownMenuItem(value: 'km/h', child: Text('km/h')),
                DropdownMenuItem(value: 'm/s', child: Text('m/s')),
                DropdownMenuItem(value: 'mph', child: Text('mph')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
