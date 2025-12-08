import 'package:flutter/material.dart';

class AppPreferencesSection extends StatelessWidget {
  final bool autoLocation;
  final bool notifications;
  final ValueChanged<bool> onAutoLocationChanged;
  final ValueChanged<bool> onNotificationsChanged;

  const AppPreferencesSection({
    super.key,
    required this.autoLocation,
    required this.notifications,
    required this.onAutoLocationChanged,
    required this.onNotificationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Auto-detect location'),
            value: autoLocation,
            onChanged: onAutoLocationChanged,
          ),
          SwitchListTile(
            title: const Text('Weather notifications'),
            value: notifications,
            onChanged: onNotificationsChanged,
          ),
        ],
      ),
    );
  }
}
