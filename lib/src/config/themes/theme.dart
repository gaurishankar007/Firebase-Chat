import 'package:flutter/material.dart';

ColorScheme lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF3287fb),
  primaryContainer: Color(0xFF0A6FFD),
  secondary: Color(0xFF140F41),
  secondaryContainer: Color(0xFF140F41),
  background: Color(0xFFFFFFFF),
  surface: Color(0xFFFFFFFF),
  error: Color(0xFFB00020),
  onPrimary: Color(0xFFFFFFFF),
  onSecondary: Color(0xFF000000),
  onBackground: Color(0xFF000000),
  onSurface: Color(0xFF000000),
  onError: Color(0xFFFFFFFF),
);

ColorScheme darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF44acfa),
  primaryContainer: Color(0xFF0A6FFD),
  secondary: Color(0xFF140F41),
  secondaryContainer: Color(0xFF140F41),
  background: Color(0xFF121212),
  surface: Color(0xFF2C2C2C),
  error: Color(0xFFCF6679),
  onPrimary: Color(0xFF000000),
  onSecondary: Color(0xFF000000),
  onBackground: Color(0xFFFFFFFF),
  onSurface: Color(0xFFFFFFFF),
  onError: Color(0xFF000000),
);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: lightScheme.background,
  colorScheme: lightScheme,
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: darkScheme.background,
  colorScheme: darkScheme,
);
