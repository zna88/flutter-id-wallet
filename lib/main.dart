import 'package:flutter/material.dart';
import 'package:flutter_id_wallet/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter_id_wallet/providers/providers.dart';
import 'package:flutter_id_wallet/screens/screens.dart';
import 'package:flutter_id_wallet/config/custom_theme.dart';
import 'package:flutter_id_wallet/repos/local_storage_settings.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(),
      ),
      ChangeNotifierProvider<DataProvider>(
        create: (_) => DataProvider(),
      ),
      ChangeNotifierProvider<LanguageProvider>(
        create: (_) => LanguageProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocalStorageSettings.isStorageReady,
      builder: (BuildContext context, snapshot) {
        final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
        Provider.of<LanguageProvider>(context).loadLanguage();
        final LanguageProvider languageProvider =
            Provider.of<LanguageProvider>(context);

        return MaterialApp(
          darkTheme: CustomTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: LoadingScreen.screenName,
          locale: Locale(
            languageProvider.currentLanguage.code,
            languageProvider.currentLanguage.countryCode,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routes: {
            LoadingScreen.screenName: (_) => LoadingScreen(),
            BottomNavScreen.screenName: (_) => BottomNavScreen(),
            SettingAppListScreen.screenName: (_) => SettingAppListScreen(),
            SettingImportScreen.screenName: (_) => SettingImportScreen(),
            LanguageScreen.screenName: (_) => LanguageScreen(),
            PasswordScreen.screenName: (_) => PasswordScreen(),
          },
          title: 'Flutter ID Wallet',
          themeMode: themeProvider.currentThemeMode,
          theme: CustomTheme.lightTheme,
        );
      },
    );
  }
}
