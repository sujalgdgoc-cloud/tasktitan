import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  var isDark = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }


  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDark.value = prefs.getBool('isDark') ?? false;

    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    isDark.value = !isDark.value;

    await prefs.setBool('isDark', isDark.value);

    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }
  ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF0F172A),
    cardColor: const Color(0xFF1E293B),

    primaryColor: const Color(0xFF38BDF8),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF38BDF8),
      secondary: Color(0xFF22C55E),
    ),

    iconTheme: const IconThemeData(
      color: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0F172A),
      foregroundColor: Colors.white,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFFE2E8F0)), // ✅ FIX
      bodySmall: TextStyle(color: Color(0xFF94A3B8)),
      titleLarge: TextStyle(
        color: Color(0xFFE2E8F0),
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}