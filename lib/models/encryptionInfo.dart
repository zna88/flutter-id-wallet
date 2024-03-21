class EncryptionInfo {
  final String encrypted;
  final String key;
  final String iv;

  EncryptionInfo(
      {required this.encrypted, required this.key, required this.iv});

  EncryptionInfo.fromJson(Map<String, dynamic> json)
      : encrypted = json['encrypted'],
        key = json['key'],
        iv = json['iv'];

  Map<String, String> toJsonEncodable() {
    Map<String, String> resultMap = Map();
    resultMap['encrypted'] = encrypted;
    resultMap['key'] = key;
    resultMap['iv'] = iv;
    return resultMap;
  }

  Map toJson() => {
        'encrypted': encrypted,
        'key': key,
        'iv': iv,
      };
}
