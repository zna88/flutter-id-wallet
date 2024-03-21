import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_id_wallet/models/models.dart';
import 'package:flutter_id_wallet/providers/helpers/aes_helper.dart';
import 'package:flutter_id_wallet/repos/local_storage_settings.dart';

class DataProvider extends ChangeNotifier {
  final ApplicationList _appList = ApplicationList();
  final ApplicationList _displayAppList = ApplicationList();
  final WalletInfoList _walletInfoList = WalletInfoList();
  final WalletInfoList _displayWalletInfoList = WalletInfoList();

  String _secretKey = '';
  String _appPassword = '';

  ApplicationList get appList => _displayAppList;
  WalletInfoList get walletInfoList => _displayWalletInfoList;
  String get secretKey => _secretKey;
  String get appPassword => _appPassword;
  bool get hasPassword => _appPassword == '' ? false : true;
  int get appListCount => _appList.applications.length;
  int get walletInfoListCount => _walletInfoList.walletInfoList.length;

  void saveApplication(String appName) {
    String appId = Application.getId();
    _displayAppList.applications.add(Application(
      appId: appId,
      appName: appName,
    ));
    _appList.applications.add(Application(
      appId: appId,
      appNameEncInfo: AESHelper.encrypt(
        appName,
        encryptionType: EncryptionType.app,
      ),
    ));
    LocalStorageSettings.saveApplicationList(_appList);
    notifyListeners();
  }

  void loadApplicationList() {
    var applications = LocalStorageSettings.getApplicationList();

    if (applications != null) {
      _displayAppList.applications = List<Application>.from(
        (applications).map(
          (app) => Application(
            appId: app['appId'],
            appName: AESHelper.decrypt(
              EncryptionInfo.fromJson(app['appNameEncInfo']),
              encryptionType: EncryptionType.app,
            ),
          ),
        ),
      );

      _appList.applications = List<Application>.from(
        (applications).map(
          (app) => Application(
            appId: app['appId'],
            appNameEncInfo: EncryptionInfo.fromJson(app['appNameEncInfo']),
          ),
        ),
      );
    }
  }

  bool deleteApplication(String appId) {
    int index =
        _displayAppList.applications.indexWhere((app) => app.appId == appId);

    if (_walletInfoList.walletInfoList
            .indexWhere((wInfo) => wInfo.appId == appId) !=
        -1) {
      return false;
    }

    _displayAppList.applications.removeAt(index);
    _appList.applications.removeAt(index);
    LocalStorageSettings.saveApplicationList(_appList);
    //notifyListeners();
    return true;
  }

  void undoDeleteApplication(int index, Application application) {
    _displayAppList.applications.insert(index, application);
    _appList.applications.insert(
        index,
        Application(
          appId: application.appId,
          appNameEncInfo: AESHelper.encrypt(
            application.appName,
            encryptionType: EncryptionType.app,
          ),
        ));
    LocalStorageSettings.saveApplicationList(_appList);
    notifyListeners();
  }

  // void toggleFavorite(String walletInfoId) {
  //   WalletInfo walletInfo = _walletInfoList.walletInfoList
  //       .firstWhere((wInfo) => wInfo.walletInfoId == walletInfoId);
  //   walletInfo.isFavorite = !walletInfo.isFavorite;

  //   int index = _walletInfoList.walletInfoList.indexOf(walletInfo);

  //   if (_displayWalletInfoList.walletInfoList.length > index) {
  //     WalletInfo displayWalletInfo = WalletInfo(
  //       walletInfoId: walletInfo.walletInfoId,
  //       appId: walletInfo.appId,
  //       appName: AESHelper.decrypt(walletInfo.appName, secretKey: secretKey),
  //       id: AESHelper.decrypt(walletInfo.id, secretKey: secretKey),
  //       password: AESHelper.decrypt(walletInfo.password, secretKey: secretKey),
  //       isFavorite: walletInfo.isFavorite,
  //     );

  //     _displayWalletInfoList.walletInfoList.removeAt(index);
  //     _displayWalletInfoList.walletInfoList.insert(index, displayWalletInfo);
  //   }

  //   _walletInfoList.walletInfoList.removeAt(index);
  //   _walletInfoList.walletInfoList.insert(index, walletInfo);

  //   LocalStorageSettings.saveWalletInfoList(_walletInfoList);
  //   notifyListeners();
  // }

  void toggleFavorite(String walletInfoId) {
    WalletInfo walletInfo = _walletInfoList.walletInfoList
        .firstWhere((wInfo) => wInfo.walletInfoId == walletInfoId);
    walletInfo.toggleFavorite();

    walletInfo = _displayWalletInfoList.walletInfoList.firstWhere(
      (wInfo) => wInfo.walletInfoId == walletInfoId,
      orElse: () => WalletInfo(
        walletInfoId: walletInfo.walletInfoId,
        appId: walletInfo.appId,
        appName:
            AESHelper.decrypt(walletInfo.appNameEncInfo!, secretKey: secretKey),
        id: AESHelper.decrypt(walletInfo.idEncInfo!, secretKey: secretKey),
        password: AESHelper.decrypt(walletInfo.passwordEncInfo!,
            secretKey: secretKey),
        isFavorite: walletInfo.isFavorite,
      ),
    );
    walletInfo.toggleFavorite();

    LocalStorageSettings.saveWalletInfoList(_walletInfoList);
    notifyListeners();
  }

  void saveWalletInfo(
    String appId,
    String appName,
    String id,
    String password,
  ) {
    String walletInfoId = WalletInfo.getId();
    _displayWalletInfoList.walletInfoList.add(WalletInfo(
      walletInfoId: walletInfoId,
      appId: appId,
      appName: appName,
      id: id,
      password: password,
    ));
    _walletInfoList.walletInfoList.add(WalletInfo(
      walletInfoId: walletInfoId,
      appId: appId,
      appNameEncInfo: AESHelper.encrypt(
        appName,
        secretKey: secretKey,
      ),
      idEncInfo: AESHelper.encrypt(
        id,
        secretKey: secretKey,
      ),
      passwordEncInfo: AESHelper.encrypt(
        password,
        secretKey: secretKey,
      ),
    ));
    LocalStorageSettings.saveWalletInfoList(_walletInfoList);
    notifyListeners();
  }

  void updateWalletInfo(WalletInfo walletInfo) {
    int displayIndex = _displayWalletInfoList.walletInfoList
        .indexWhere((wInfo) => wInfo.walletInfoId == walletInfo.walletInfoId);

    int index = _walletInfoList.walletInfoList
        .indexWhere((wInfo) => wInfo.walletInfoId == walletInfo.walletInfoId);

    if (index > -1) {
      _displayWalletInfoList.walletInfoList.removeAt(displayIndex);
      _displayWalletInfoList.walletInfoList.insert(displayIndex, walletInfo);

      _walletInfoList.walletInfoList.removeAt(index);
      _walletInfoList.walletInfoList.insert(
          index,
          WalletInfo(
            walletInfoId: walletInfo.walletInfoId,
            appId: walletInfo.appId,
            appNameEncInfo:
                AESHelper.encrypt(walletInfo.appName, secretKey: secretKey),
            idEncInfo: AESHelper.encrypt(walletInfo.id, secretKey: secretKey),
            passwordEncInfo:
                AESHelper.encrypt(walletInfo.password, secretKey: secretKey),
            isFavorite: walletInfo.isFavorite,
          ));

      LocalStorageSettings.saveWalletInfoList(_walletInfoList);
      notifyListeners();
    }
  }

  void deleteWalletInfo(String walletInfoId) {
    int displayIndex = _displayWalletInfoList.walletInfoList
        .indexWhere((wInfo) => wInfo.walletInfoId == walletInfoId);

    int index = _walletInfoList.walletInfoList
        .indexWhere((wInfo) => wInfo.walletInfoId == walletInfoId);

    if (displayIndex > -1 && index > -1) {
      _displayWalletInfoList.walletInfoList.removeAt(displayIndex);
      _walletInfoList.walletInfoList.removeAt(index);
      LocalStorageSettings.saveWalletInfoList(_walletInfoList);
      notifyListeners();
    }
  }

  void undoDeleteWalletInfo(int index, WalletInfo walletInfo) {
    _displayWalletInfoList.walletInfoList.insert(index, walletInfo);
    _walletInfoList.walletInfoList.insert(
        index,
        WalletInfo(
          walletInfoId: walletInfo.walletInfoId,
          appId: walletInfo.appId,
          appNameEncInfo: AESHelper.encrypt(
            walletInfo.appName,
            secretKey: secretKey,
          ),
          idEncInfo: AESHelper.encrypt(
            walletInfo.id,
            secretKey: secretKey,
          ),
          passwordEncInfo: AESHelper.encrypt(
            walletInfo.password,
            secretKey: secretKey,
          ),
          isFavorite: walletInfo.isFavorite,
        ));
    LocalStorageSettings.saveWalletInfoList(_walletInfoList);
    notifyListeners();
  }

  void loadWalletInfoList({
    String appId = '',
    bool isFavoriteOnly = false,
  }) {
    var walletInfos = LocalStorageSettings.getWalletInfoList();

    if (walletInfos != null) {
      _walletInfoList.walletInfoList = List<WalletInfo>.from(
        (walletInfos).map(
          (walletInfo) => WalletInfo(
            walletInfoId: walletInfo['walletInfoId'],
            appId: walletInfo['appId'],
            appNameEncInfo: EncryptionInfo.fromJson(
              walletInfo['appNameEncInfo'],
            ),
            idEncInfo: EncryptionInfo.fromJson(
              walletInfo['idEncInfo'],
            ),
            passwordEncInfo: EncryptionInfo.fromJson(
              walletInfo['passwordEncInfo'],
            ),
            isFavorite: walletInfo['isFavorite'],
            canDecrypt: AESHelper.decrypt(
                      EncryptionInfo.fromJson(walletInfo['appNameEncInfo']),
                      secretKey: secretKey,
                    ) ==
                    ''
                ? false
                : true,
          ),
        ),
      );

      _displayWalletInfoList.walletInfoList = List<WalletInfo>.from(
        (walletInfos).map((walletInfo) {
          final String decryptedAppName = AESHelper.decrypt(
            EncryptionInfo.fromJson(walletInfo['appNameEncInfo']),
            secretKey: secretKey,
          );
          final String decryptedId = AESHelper.decrypt(
            EncryptionInfo.fromJson(walletInfo['idEncInfo']),
            secretKey: secretKey,
          );
          final String decryptedPassword = AESHelper.decrypt(
            EncryptionInfo.fromJson(walletInfo['passwordEncInfo']),
            secretKey: secretKey,
          );

          return WalletInfo(
            walletInfoId: walletInfo['walletInfoId'],
            appId: walletInfo['appId'],
            appName: decryptedAppName,
            id: decryptedId,
            password: decryptedPassword,
            isFavorite: walletInfo['isFavorite'],
            canDecrypt: decryptedPassword.isEmpty &&
                    decryptedId.isEmpty &&
                    decryptedPassword.isEmpty
                ? false
                : true,
          );
        }),
      );

      if (appId.toLowerCase() != '') {
        _displayWalletInfoList.walletInfoList = _displayWalletInfoList
            .walletInfoList
            .where((walletInfo) => walletInfo.appId == appId)
            .toList();
      }

      if (isFavoriteOnly) {
        _displayWalletInfoList.walletInfoList = _displayWalletInfoList
            .walletInfoList
            .where((walletInfo) => walletInfo.isFavorite == true)
            .toList();
      }
    }
  }

  void saveSecretKey(String secretKey) {
    _secretKey = secretKey;
    if (_secretKey.isEmpty) {
      LocalStorageSettings.saveSecretKey(null);
      return;
    }

    EncryptionInfo encryptionInfo = AESHelper.encrypt(
      secretKey,
      encryptionType: EncryptionType.app,
    );
    LocalStorageSettings.saveSecretKey(jsonEncode(encryptionInfo.toJson()));
  }

  void loadSecretKey() {
    _secretKey = LocalStorageSettings.getSecretKey();
    if (_secretKey.isNotEmpty) {
      EncryptionInfo encryptionInfo = EncryptionInfo.fromJson(
          jsonDecode(LocalStorageSettings.getSecretKey()));
      _secretKey = AESHelper.decrypt(
        encryptionInfo,
        encryptionType: EncryptionType.app,
      );
    }
  }

  void saveAppPassword(String password) {
    _appPassword = password;
    if (password.isNotEmpty) {
      EncryptionInfo encryptionInfo = AESHelper.encrypt(
        password,
        encryptionType: EncryptionType.app,
      );
      LocalStorageSettings.saveAppPassword(jsonEncode(encryptionInfo.toJson()));
      notifyListeners();
    }
  }

  void loadAppPassword() {
    _appPassword = LocalStorageSettings.getAppPassword();
    if (_appPassword.isNotEmpty) {
      EncryptionInfo encryptionInfo =
          EncryptionInfo.fromJson(jsonDecode(_appPassword));
      _appPassword = AESHelper.decrypt(
        encryptionInfo,
        encryptionType: EncryptionType.app,
      );
    }
  }

  String exportDataJSONString({isEncrypted = false}) {
    loadWalletInfoList();
    AppData exportData = AppData(
      secretKey: secretKey,
      applicationList: _appList.applications,
      walletInfoList: _walletInfoList.walletInfoList,
    );

    String jsonEncodedValue = jsonEncode(exportData);
    String result = isEncrypted
        ? jsonEncode(AESHelper.encrypt(
            jsonEncodedValue,
            encryptionType: EncryptionType.app,
          ).toJson())
        : jsonEncodedValue;
    return base64.encode(utf8.encode(result));
  }

  AppData? getImportedAppData(String encryptedText) {
    if (encryptedText.isEmpty) return null;

    String base64DecodedText = utf8.decode(base64.decode(encryptedText));
    String decryptedResult = AESHelper.decrypt(
      EncryptionInfo.fromJson(jsonDecode(base64DecodedText)),
      encryptionType: EncryptionType.app,
    );

    if (decryptedResult.isEmpty) return null;

    Map<String, dynamic> jsonResult = jsonDecode(decryptedResult);
    AppData appData = AppData.fromJson(jsonResult);
    return appData;
  }

  Future<void> mergeAppData(AppData importedAppData) async {
    List<WalletInfo> importedWalletInfoList =
        _getImportedWalletInfoList(importedAppData);

    /* Merge Application */
    for (Application app in importedAppData.applicationList) {
      int index = _appList.applications.indexWhere((a) => a.appId == app.appId);

      if (index == -1) {
        _appList.applications.add(
          Application(
            appId: app.appId,
            appNameEncInfo: AESHelper.encrypt(
              app.appName,
              encryptionType: EncryptionType.app,
            ),
          ),
        );
      }
    }

    await LocalStorageSettings.saveApplicationList(_appList);

    /* Merge Wallet Info */
    for (WalletInfo wInfo in importedWalletInfoList) {
      int index = _walletInfoList.walletInfoList
          .indexWhere((w) => w.walletInfoId == wInfo.walletInfoId);

      if (index == -1) {
        _walletInfoList.walletInfoList.add(wInfo);
      }
    }

    await LocalStorageSettings.saveWalletInfoList(_walletInfoList);
  }

  Future<void> overwriteAppData(AppData importedAppData) async {
    List<WalletInfo> importedWalletInfoList =
        _getImportedWalletInfoList(importedAppData);

    /* Clear application data */
    _appList.applications.clear();
    _walletInfoList.walletInfoList.clear();

    /* Add Application data */
    for (Application app in importedAppData.applicationList) {
      _appList.applications.add(
        Application(
          appId: app.appId,
          appNameEncInfo: app.appNameEncInfo,
        ),
      );
    }

    /* Save Application data into local storage */
    await LocalStorageSettings.saveApplicationList(_appList);

    /* Add Wallet Info data */
    _walletInfoList.walletInfoList = importedWalletInfoList;

    /* Save Wallet Info data into local storage */
    await LocalStorageSettings.saveWalletInfoList(_walletInfoList);

    /* Save Secret Key into local storage */
    saveSecretKey(importedAppData.secretKey);
  }

  List<WalletInfo> _getImportedWalletInfoList(AppData importedAppData) {
    /* Retrieve Wallet Info list from imported app data */
    return importedAppData.walletInfoList.map<WalletInfo>(
      (w) {
        /*if (w.canDecrypt) {
          final String appName = AESHelper.decrypt(
            w.appNameEncInfo!,
            secretKey: importedAppData.secretKey,
          );
          final String id = AESHelper.decrypt(
            w.idEncInfo!,
            secretKey: importedAppData.secretKey,
          );
          final String password = AESHelper.decrypt(
            w.passwordEncInfo!,
            secretKey: importedAppData.secretKey,
          );

          return WalletInfo(
            walletInfoId: w.walletInfoId,
            appId: w.appId,
            appNameEncInfo: AESHelper.encrypt(
              appName,
              secretKey: secretKey,
            ),
            idEncInfo: AESHelper.encrypt(
              id,
              secretKey: secretKey,
            ),
            passwordEncInfo: AESHelper.encrypt(
              password,
              secretKey: secretKey,
            ),
            isFavorite: w.isFavorite,
            canDecrypt: w.canDecrypt,
          );
        }*/

        return WalletInfo(
          walletInfoId: w.walletInfoId,
          appId: w.appId,
          appNameEncInfo: w.appNameEncInfo,
          idEncInfo: w.idEncInfo,
          passwordEncInfo: w.passwordEncInfo,
          isFavorite: w.isFavorite,
          canDecrypt: w.canDecrypt,
        );
      },
    ).toList();
  }
}
