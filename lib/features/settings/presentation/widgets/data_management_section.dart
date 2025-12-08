import 'package:flutter/material.dart';

class DataManagementSection extends StatelessWidget {
  final VoidCallback onClearFavorites;
  final VoidCallback onClearAll;

  const DataManagementSection({
    super.key,
    required this.onClearFavorites,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Clear favorites'),
            trailing: const Icon(Icons.favorite_border),
            onTap: onClearFavorites,
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Clear all data'),
            trailing: const Icon(Icons.delete_outline),
            onTap: onClearAll,
          ),
        ],
      ),
    );
  }
}
