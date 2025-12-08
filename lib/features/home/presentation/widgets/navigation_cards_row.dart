import 'package:flutter/material.dart';

class NavigationCardsRow extends StatelessWidget {
  const NavigationCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () => Navigator.of(context).pushNamed('/favorites'),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Card(
            child: ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.of(context).pushNamed('/settings'),
            ),
          ),
        ),
      ],
    );
  }
}
