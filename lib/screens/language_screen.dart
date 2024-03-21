import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flag/flag.dart';

import 'package:flutter_id_wallet/models/models.dart';
import 'package:flutter_id_wallet/providers/providers.dart';
import 'package:flutter_id_wallet/widgets/widgets.dart';

class LanguageScreen extends StatelessWidget {
  static const String screenName = '/languageScreen';

  Widget _getCurrentLanguage(
    LanguageProvider languageProvider,
    ThemeProvider themeProvider,
  ) {
    Language currentLanguage = languageProvider.currentLanguage;

    return InkWell(
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Flag.fromCode(
              currentLanguage.flagsCode,
              fit: BoxFit.fitWidth,
              width: 27.0,
            ),
          ),
          title: Text(currentLanguage.description),
          trailing: Icon(Icons.check),
        ),
      ),
      onTap: () {},
    );
  }

  List<Widget> _getAvailableLanguages(
    BuildContext context,
    LanguageProvider languageProvider,
    ThemeProvider themeProvider,
  ) {
    List<Language> availableLanguages = languageProvider.availableLanguages;

    return availableLanguages
        .map(
          (lang) => InkWell(
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Flag.fromCode(
                    lang.flagsCode,
                    fit: BoxFit.fitWidth,
                    width: 27.0,
                  ),
                ),
                title: Text(lang.description),
              ),
            ),
            onTap: () {
              Provider.of<LanguageProvider>(context, listen: false)
                  .saveLanguage(lang.code);
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    final LanguageProvider languageProvider =
        Provider.of<LanguageProvider>(context);
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: appLocalizations!.settingLanguageScreenTitle,
      ),
      body: Container(
        child: Column(
          children: [
            Text(
              appLocalizations.settingCurrentLanguage,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.0),
            Container(
              child: _getCurrentLanguage(languageProvider, themeProvider),
            ),
            Divider(height: 30.0),
            Text(
              appLocalizations.settingAvailableLanguages,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.0),
            Column(
              children: _getAvailableLanguages(
                context,
                languageProvider,
                themeProvider,
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        padding: EdgeInsets.all(5.0),
      ),
    );
  }
}
