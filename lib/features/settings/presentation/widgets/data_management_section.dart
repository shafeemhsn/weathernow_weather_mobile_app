import 'package:flutter/material.dart';

class DataManagementSection extends StatelessWidget {
  const DataManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Clear all data'),
        trailing: const Icon(Icons.delete_outline),
        onTap: () {},
      ),
    );
  }
}
