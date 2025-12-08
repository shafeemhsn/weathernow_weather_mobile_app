import 'package:flutter/material.dart';

class FavouritesSearchField extends StatelessWidget {
  final ValueChanged<String> onSearch;

  const FavouritesSearchField({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search favorites',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
      onChanged: onSearch,
      onSubmitted: onSearch,
    );
  }
}
