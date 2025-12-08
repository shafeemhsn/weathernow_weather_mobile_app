import 'package:flutter/material.dart';

class QuickCitiesGrid extends StatelessWidget {
  final List<String> cities;

  const QuickCitiesGrid({super.key, required this.cities});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];
        return ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed('/weather', arguments: {'city': city}),
          child: Text(city),
        );
      },
    );
  }
}
