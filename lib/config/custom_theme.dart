import 'package:flutter/material.dart';

import 'package:flutter_id_wallet/config/pallete.dart';

class CustomTheme {
  static final darkTheme = ThemeData(
    colorScheme:
        ColorScheme.dark().copyWith(secondary: Pallete.accentColorDark),
    dialogBackgroundColor: Pallete.dialogBackgroundColorDark,
    primaryColor: Pallete.primaryColorDark,
    scaffoldBackgroundColor: Pallete.scaffoldBackgroundColorDark,
  );

  static final lightTheme = ThemeData(
    colorScheme:
        ColorScheme.light().copyWith(secondary: Pallete.accentColorLight),
    dialogBackgroundColor: Pallete.dialogBackgroundColorLight,
    primaryColor: Pallete.primaryColorLight,
    scaffoldBackgroundColor: Pallete.scaffoldBackgroundColorLight,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Pallete.bottomNavBarBackgroundColorLight,
    ),
  );
}
