import 'package:flag/flag.dart';

class Language {
  final String code;
  final String countryCode;
  final String description;
  final FlagsCode flagsCode;

  Language({
    required this.code,
    required this.countryCode,
    required this.description,
    required this.flagsCode,
  });
}
