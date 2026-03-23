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
}