import 'package:localstorage/localstorage.dart';

import 'package:flutter_id_wallet/models/models.dart';

class LocalStorageSettings {
  static const String _APPILICATION_STORAGE_ID = 'flutter_id_wallet_app';
  static const String _SETTINGS_DARKMODE_ON = 'Settings_DarkModeOn';
  static const String _SETTINGS_APPLICATION_LIST = 'Settings_ApplicationList';
  static const String _SETTINGS_WALLET_INFO_LIST = 'Settings_WalletInfoList';
  static const String _SETTINGS_SECRET_KEY = 'Settings_SecretKey';
  static const String _SETTINGS_APP_PASSWORD = 'Settings_AppPassword';
  static const String _SETTINGS_APP_LANGUAGE = 'Settings_Language';

  static final LocalStorage _storage = LocalStorage(_APPILICATION_STORAGE_ID);

  static Future<bool> get isStorageReady => _storage.ready;

  static Future<void> setDarkModeOnValue(bool value) async {
    await _storage.setItem(_SETTINGS_DARKMODE_ON, value);
  }

  static bool getDarkModeOnValue() {
    var result = _storage.getItem(_SETTINGS_DARKMODE_ON);
    if (result == null) {
      return false;
    }
    return result as bool;
  }

  static Future<void> saveApplicationList(
      ApplicationList applicationList) async {
    await _storage.setItem(
      _SETTINGS_APPLICATION_LIST,
      applicationList.toJSONEncodable(),
    );
  }

  static dynamic getApplicationList() {
    return _storage.getItem(_SETTINGS_APPLICATION_LIST);
  }

  static Future<void> saveWalletInfoList(WalletInfoList walletInfoList) async {
    await _storage.setItem(
      _SETTINGS_WALLET_INFO_LIST,
      walletInfoList.toJSONEncodable(),
    );
  }

  static dynamic getWalletInfoList() {
    return _storage.getItem(_SETTINGS_WALLET_INFO_LIST);
  }

  static Future<void> saveSecretKey(String? secretKey) async {
    await _storage.setItem(_SETTINGS_SECRET_KEY, secretKey);
  }

  static String getSecretKey() {
    String result = '';
    var secretKey = _storage.getItem(_SETTINGS_SECRET_KEY);
    if (secretKey != null) {
      result = secretKey as String;
    }
    return result;
  }

  static Future<void> saveAppPassword(String password) async {
    await _storage.setItem(_SETTINGS_APP_PASSWORD, password);
  }

  static String getAppPassword() {
    String result = '';
    var appPassword = _storage.getItem(_SETTINGS_APP_PASSWORD);
    if (appPassword != null) {
      result = appPassword as String;
    }
    return result;
  }

  static Future<void> saveLanguage(String languageCode) async {
    await _storage.setItem(_SETTINGS_APP_LANGUAGE, languageCode);
  }

  static String getLanguage() {
    String result = 'en';
    var language = _storage.getItem(_SETTINGS_APP_LANGUAGE);
    if (language != null) {
      result = language as String;
    }
    return result;
  }
}
