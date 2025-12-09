import 'package:flutter/material.dart';

class FavoritesSearchField extends StatelessWidget {
  final ValueChanged<String> onSearch;

  const FavoritesSearchField({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search favorites',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: onSearch,
      onSubmitted: onSearch,
    );
  }
}
