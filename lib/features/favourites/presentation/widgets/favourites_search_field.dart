import 'package:flutter/material.dart';

class FavouritesSearchField extends StatelessWidget {
  final ValueChanged<String> onSearch;

  const FavouritesSearchField({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search favorites',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      onChanged: onSearch,
      onSubmitted: onSearch,
    );
  }
}
