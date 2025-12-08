import 'package:flutter/material.dart';

class CityNotFoundCard extends StatelessWidget {
  final String? city;
  final VoidCallback onSearchAgain;

  const CityNotFoundCard({
    super.key,
    required this.city,
    required this.onSearchAgain,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cityLabel =
        city != null && city!.trim().isNotEmpty ? '"${city!.trim()}"' : 'the city you searched';

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF3955D1), Color(0xFF5AA5FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(Icons.location_off_outlined, size: 42, color: Colors.white),
                ),
                const SizedBox(height: 14),
                Text(
                  'City not found',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'We couldn\'t find weather data for $cityLabel.\nDouble-check the spelling or search for a nearby city.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black87, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    Chip(
                      avatar: Icon(Icons.error_outline, size: 18),
                      label: Text('Error 404'),
                    ),
                    Chip(
                      avatar: Icon(Icons.tips_and_updates_outlined, size: 18),
                      label: Text('Try another spelling'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onSearchAgain,
                    icon: const Icon(Icons.search),
                    label: const Text('Back to search'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
