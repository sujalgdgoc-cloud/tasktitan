import 'package:flutter/material.dart';
const Color backgroundColor = Color(0xFF0F172A);
const Color cardColor = Color(0xFF1E293B);
const Color primaryColor = Color(0xFF38BDF8);
const Color accentColor = Color(0xFF22C55E);
const Color textColor = Color(0xFFE2E8F0);
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,

  scaffoldBackgroundColor: const Color(0xFFF8FAFC),
  cardColor: const Color(0xFFFFFFFF),

  primaryColor: primaryColor,

  colorScheme: const ColorScheme.light(
    primary: primaryColor,
    secondary: accentColor,
  ),

  iconTheme: const IconThemeData(
    color: Color(0xFF334155),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF8FAFC),
    foregroundColor: Color(0xFF0F172A),
    iconTheme: IconThemeData(color: Color(0xFF334155)),
  ),

  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF0F172A)),
    bodySmall: TextStyle(color: Color(0xFF64748B)),
    titleLarge: TextStyle(
      color: Color(0xFF0F172A),
      fontWeight: FontWeight.bold,
    ),
  ),
);
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,

  scaffoldBackgroundColor: backgroundColor,
  cardColor: cardColor,

  primaryColor: primaryColor,

  colorScheme: const ColorScheme.dark(
    primary: primaryColor,
    secondary: accentColor,
  ),

  iconTheme: const IconThemeData(
    color: primaryColor,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: backgroundColor,
    foregroundColor: textColor,
    iconTheme: IconThemeData(color: primaryColor),
  ),

  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: textColor),
    bodySmall: TextStyle(color: Color(0xFF94A3B8)),
    titleLarge: TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
    ),
  ),
);