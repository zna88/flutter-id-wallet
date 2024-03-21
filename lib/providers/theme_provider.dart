import 'package:flutter/material.dart';

import 'package:flutter_id_wallet/repos/local_storage_settings.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode get currentThemeMode {
    return LocalStorageSettings.getDarkModeOnValue()
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  bool get isDarkMode {
    return LocalStorageSettings.getDarkModeOnValue();
  }

  Future<void> toggleTheme(bool isDarkModeOn) async {
    await LocalStorageSettings.setDarkModeOnValue(isDarkModeOn);
    notifyListeners();
  }
}
