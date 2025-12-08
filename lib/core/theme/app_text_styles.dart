import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
  );

  static TextTheme get textTheme => const TextTheme(
        headlineMedium: headline,
        bodyMedium: body,
      );
}
