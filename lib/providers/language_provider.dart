import 'package:flutter/material.dart';
import 'package:flag/flag.dart';

import 'package:flutter_id_wallet/models/models.dart';
import 'package:flutter_id_wallet/repos/local_storage_settings.dart';

class LanguageProvider extends ChangeNotifier {
  final List<Language> _languages = [
    Language(
      code: 'en',
      countryCode: 'US',
      description: 'English (US)',
      flagsCode: FlagsCode.US,
    ),
    Language(
      code: 'my',
      countryCode: 'MM',
      description: 'မြန်မာ',
      flagsCode: FlagsCode.MM,
    ),
  ];

  String _appLanguage = 'en';

  Language get currentLanguage {
    return _languages.firstWhere((lang) => lang.code == _appLanguage);
  }

  List<Language> get availableLanguages {
    return _languages.where((lang) => lang.code != _appLanguage).toList();
  }

  void saveLanguage(String languageCode) {
    _appLanguage = languageCode;
    LocalStorageSettings.saveLanguage(languageCode);
    notifyListeners();
  }

  void loadLanguage() {
    _appLanguage = LocalStorageSettings.getLanguage();
  }
}
