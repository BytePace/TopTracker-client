import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData.light().copyWith(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.white70,
    secondary: Colors.grey.shade400,
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(fontSize: 8),
  ),
);
