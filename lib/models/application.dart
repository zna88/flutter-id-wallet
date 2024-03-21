import 'package:flutter_id_wallet/models/encryptionInfo.dart';

class Application {
  final String appId;
  final String appName;
  final EncryptionInfo? appNameEncInfo;

  Application({
    this.appId = '',
    this.appName = '',
    this.appNameEncInfo,
  });

  static String getId() {
    return 'APP_' + DateTime.now().microsecondsSinceEpoch.toString();
  }

  Application.fromJson(Map<String, dynamic> json)
      : appId = json['appId'],
        appName = json['appName'] != null ? json['appName'] : '',
        appNameEncInfo = EncryptionInfo.fromJson(json['appNameEncInfo']);

  Map<String, dynamic> toJSONEncodable() {
    Map<String, dynamic> resultMap = Map();
    resultMap['appId'] = appId;
    resultMap['appName'] = appName;
    resultMap['appNameEncInfo'] = appNameEncInfo!.toJsonEncodable();
    return resultMap;
  }

  Map toJson() => {
        'appId': appId,
        'appNameEncInfo': appNameEncInfo!.toJson(),
      };
}

class ApplicationList {
  List<Application> applications = <Application>[];

  List<Map<String, dynamic>> toJSONEncodable() {
    return applications.map((app) => app.toJSONEncodable()).toList();
  }
}
