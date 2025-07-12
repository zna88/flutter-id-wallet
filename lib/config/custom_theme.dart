import 'package:flutter/material.dart';

import 'package:flutter_id_wallet/config/pallete.dart';

class CustomTheme {
  static final darkTheme = ThemeData(
    colorScheme:
        ColorScheme.dark().copyWith(secondary: Pallete.accentColorDark),
    primaryColor: Pallete.primaryColorDark,
    scaffoldBackgroundColor: Pallete.scaffoldBackgroundColorDark, dialogTheme: DialogThemeData(backgroundColor: Pallete.dialogBackgroundColorDark),
  );

  static final lightTheme = ThemeData(
    colorScheme:
        ColorScheme.light().copyWith(secondary: Pallete.accentColorLight),
    primaryColor: Pallete.primaryColorLight,
    scaffoldBackgroundColor: Pallete.scaffoldBackgroundColorLight,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Pallete.bottomNavBarBackgroundColorLight,
    ), dialogTheme: DialogThemeData(backgroundColor: Pallete.dialogBackgroundColorLight),
  );
}
