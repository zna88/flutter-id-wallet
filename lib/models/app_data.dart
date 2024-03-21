import 'package:flutter_id_wallet/models/application.dart';
import 'package:flutter_id_wallet/models/wallet_info.dart';

class AppData {
  final String secretKey;
  final List<Application> applicationList;
  final List<WalletInfo> walletInfoList;

  AppData({
    required this.secretKey,
    required this.applicationList,
    required this.walletInfoList,
  });

  AppData.fromJson(Map<String, dynamic> json)
      : secretKey = json['secretKey'],
        applicationList = (json['applicationList'] as List)
            .map((e) => Application.fromJson(e))
            .toList(),
        walletInfoList = (json['walletInfoList'] as List)
            .map((e) => WalletInfo.fromJson(e))
            .toList();

  Map toJson() => {
        'secretKey': secretKey,
        'applicationList': applicationList,
        'walletInfoList': walletInfoList,
      };
}
