import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../router/app_router.dart';

class NavigationCardsRow extends StatelessWidget {
  const NavigationCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppCard(
            accent: const Color(0xFF5C6BC0),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: _iconBadge(Icons.favorite, const Color(0xFF5C6BC0)),
              title: const Text('Favorites'),
              onTap: () => Navigator.of(context).pushNamed(AppRouter.favourites),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AppCard(
            accent: const Color(0xFF26A69A),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: _iconBadge(Icons.settings, const Color(0xFF26A69A)),
              title: const Text('Settings'),
              onTap: () => Navigator.of(context).pushNamed(AppRouter.settings),
            ),
          ),
        ),
      ],
    );
  }

  Widget _iconBadge(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color),
    );
  }
}
