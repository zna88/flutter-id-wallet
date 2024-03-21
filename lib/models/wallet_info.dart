import 'dart:convert';

import 'package:flutter_id_wallet/models/encryptionInfo.dart';

class WalletInfo {
  final String walletInfoId;
  final String appId;
  final String appName;
  final String id;
  final String password;
  final EncryptionInfo? appNameEncInfo;
  final EncryptionInfo? idEncInfo;
  final EncryptionInfo? passwordEncInfo;
  bool isFavorite;
  bool canDecrypt;

  WalletInfo({
    this.walletInfoId = '',
    this.appId = '',
    this.appName = '',
    this.id = '',
    this.password = '',
    this.isFavorite = false,
    this.canDecrypt = true,
    this.appNameEncInfo,
    this.idEncInfo,
    this.passwordEncInfo,
  });

  static String getId() {
    return 'WALLET_INFO_' + DateTime.now().microsecondsSinceEpoch.toString();
  }

  factory WalletInfo.fromJson(Map<String, dynamic> json) => WalletInfo(
        walletInfoId: json['walletInfoId'],
        appId: json['appId'],
        appName: json['appName'] != null ? json['appName'] : '',
        id: json['id'] != null ? json['id'] : '',
        password: json['password'] != null ? json['password'] : '',
        isFavorite: json['isFavorite'],
        canDecrypt: json['canDecrypt'],
        appNameEncInfo: EncryptionInfo.fromJson(json['appNameEncInfo']),
        idEncInfo: EncryptionInfo.fromJson(json['idEncInfo']),
        passwordEncInfo: EncryptionInfo.fromJson(json['passwordEncInfo']),
      );

  // WalletInfo.fromJson(Map<String, dynamic> json)
  //     : walletInfoId = json['walletInfoId'],
  //       appId = json['appId'],
  //       appName = json['appName'],
  //       id = json['id'],
  //       password = json['password'],
  //       isFavorite = json['isFavorite'],
  //       canDecrypt = json['canDecrypt'];

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }

  Map<String, dynamic> toJSONEncodable() {
    Map<String, dynamic> resultMap = Map();
    resultMap['walletInfoId'] = walletInfoId;
    resultMap['appId'] = appId;
    resultMap['appName'] = appName;
    resultMap['id'] = id;
    resultMap['password'] = password;
    resultMap['appNameEncInfo'] = appNameEncInfo!.toJsonEncodable();
    resultMap['idEncInfo'] = idEncInfo!.toJsonEncodable();
    resultMap['passwordEncInfo'] = passwordEncInfo!.toJsonEncodable();
    resultMap['isFavorite'] = isFavorite;
    resultMap['canDecrypt'] = canDecrypt;
    return resultMap;
  }

  Map toJson() => {
        'walletInfoId': walletInfoId,
        'appId': appId,
        'appNameEncInfo': appNameEncInfo!.toJson(),
        'idEncInfo': idEncInfo!.toJson(),
        'passwordEncInfo': passwordEncInfo!.toJson(),
        'isFavorite': isFavorite,
        'canDecrypt': canDecrypt,
      };
}

class WalletInfoList {
  List<WalletInfo> walletInfoList = <WalletInfo>[];

  List<Map<String, dynamic>> toJSONEncodable() {
    return walletInfoList
        .map((walletInfo) => walletInfo.toJSONEncodable())
        .toList();
  }

  String toJSONString() {
    return jsonEncode(walletInfoList);
  }
}
