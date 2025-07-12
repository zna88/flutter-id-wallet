import 'package:flutter/material.dart';
import 'package:flutter_id_wallet/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flag/flag.dart';

import 'package:flutter_id_wallet/providers/providers.dart';
import 'package:flutter_id_wallet/widgets/widgets.dart';
import 'package:flutter_id_wallet/screens/language_screen.dart';
import 'package:flutter_id_wallet/screens/password_screen.dart';
import 'package:flutter_id_wallet/screens/setting_app_list_screen.dart';
import 'package:flutter_id_wallet/screens/setting_import_screen.dart';
import 'package:flutter_id_wallet/screens/helpers/dialog_helper.dart';
import 'package:flutter_id_wallet/screens/helpers/message_helper.dart';

class SettingScreen extends StatelessWidget {
  void _showExportDialog(
      BuildContext context, AppLocalizations appLocalizations) {
    final String exportData = Provider.of<DataProvider>(context, listen: false)
        .exportDataJSONString(isEncrypted: true);
    final exportDataController = TextEditingController(text: exportData);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => DialogMain(
        cancelButtonText: appLocalizations.dialogBtnClose,
        contentWidget: ContentWidget.export,
        dialogType: DialogType.info,
        extraButtons: [
          CustomIconButton(
            leadingIcon: Icons.copy,
            buttonText: appLocalizations.settingExportDialogBtnCopy,
            onPressed: () {
              FlutterClipboard.copy(exportDataController.text).then(
                (value) => MessageHelper.showSnackBarMessage(
                  context,
                  appLocalizations
                      .messageCopiedParam(appLocalizations.labelData),
                  displayDuration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
        textEditingControllers: [
          exportDataController,
        ],
        titleText: appLocalizations.settingExport,
      ),
    );
  }

  void _showAddSecretKeyDialog(
      BuildContext context, AppLocalizations appLocalizations) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final secretKeyController =
        TextEditingController(text: dataProvider.secretKey);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => DialogMain(
        cancelButtonText: appLocalizations.dialogBtnClose,
        contentWidget: ContentWidget.addSecretKey,
        dialogType: DialogType.editor,
        onSubmitHandler: () {
          dataProvider.saveSecretKey(secretKeyController.text);
          Navigator.of(context).pop();
        },
        submitButtonText: appLocalizations.dialogBtnSave,
        textEditingControllers: [
          secretKeyController,
        ],
        titleText: appLocalizations.settingSecretKeyDialogTitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<DataProvider>(context, listen: false).loadSecretKey();
    Provider.of<LanguageProvider>(context, listen: false).loadLanguage();
    final LanguageProvider languageProvider =
        Provider.of<LanguageProvider>(context);
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: appLocalizations!.settingScreenTitle,
        leadingWidget: Icon(Icons.settings),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTileSetting(
                  leadingIcon: Icons.dark_mode,
                  subtitleText: appLocalizations.settingDarkModeDescription,
                  titleText: appLocalizations.settingDarkMode,
                  trailingWidget: SwitchChangeTheme(),
                ),
                Divider(),
                InkWell(
                  child: ListTileSetting(
                    leadingIcon: Icons.language,
                    subtitleText: appLocalizations.settingLanguageDescription,
                    titleText: appLocalizations.settingLanguageScreenTitle,
                    trailingWidget: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Flag.fromCode(
                            languageProvider.currentLanguage.flagsCode,
                            fit: BoxFit.fitWidth,
                            width: 27.0,
                          ),
                          foregroundColor: Colors.white,
                          radius: 18.0,
                        ),
                        Text(
                          languageProvider.currentLanguage.description,
                          style: TextStyle(
                            fontSize: Localizations.localeOf(context)
                                        .toString()
                                        .toUpperCase() ==
                                    'MY'
                                ? 9.0
                                : 11.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(LanguageScreen.screenName);
                  },
                ),
                Divider(),
                InkWell(
                  child: ListTileSetting(
                    leadingIcon: Icons.app_registration,
                    subtitleText:
                        appLocalizations.settingApplicationListDescription,
                    titleText: appLocalizations.settingApplicationListTitle,
                  ),
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (_) => SettingAppListScreen(),
                    //   ),
                    // );
                    Navigator.of(context)
                        .pushNamed(SettingAppListScreen.screenName);
                  },
                ),
                Divider(),
                InkWell(
                  child: ListTileSetting(
                    leadingIcon: Icons.upload,
                    subtitleText: appLocalizations.settingImportDescription,
                    titleText: appLocalizations.settingImport,
                  ),
                  onTap: () {
                    // _showImportDialog();
                    Navigator.of(context)
                        .pushNamed(SettingImportScreen.screenName);
                  },
                ),
                Divider(),
                InkWell(
                  child: ListTileSetting(
                    leadingIcon: Icons.download,
                    subtitleText: appLocalizations.settingExportDescription,
                    titleText: appLocalizations.settingExport,
                  ),
                  onTap: () {
                    final DataProvider dataProvider =
                        Provider.of<DataProvider>(context, listen: false);

                    if (dataProvider.hasPassword) {
                      DialogHelper.showAuthenticateDialog(
                        context,
                        appLocalizations,
                        () {
                          _showExportDialog(context, appLocalizations);
                        },
                      );
                    } else {
                      _showExportDialog(context, appLocalizations);
                    }
                  },
                ),
                Divider(),
                InkWell(
                  child: ListTileSetting(
                    leadingIcon: Icons.vpn_key,
                    subtitleText: appLocalizations.settingSecretKeyDescription,
                    titleText: appLocalizations.settingSecretKey,
                  ),
                  onTap: () {
                    final DataProvider dataProvider =
                        Provider.of<DataProvider>(context, listen: false);

                    if (dataProvider.hasPassword) {
                      DialogHelper.showAuthenticateDialog(
                        context,
                        appLocalizations,
                        () {
                          _showAddSecretKeyDialog(context, appLocalizations);
                        },
                      );
                    } else {
                      _showAddSecretKeyDialog(context, appLocalizations);
                    }
                  },
                ),
                Divider(),
                InkWell(
                  child: ListTileSetting(
                    leadingIcon: Icons.password,
                    subtitleText: appLocalizations.settingPasswordDescription,
                    titleText: appLocalizations.settingPasswordTitle,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(PasswordScreen.screenName);
                  },
                ),
                Divider(),
                InkWell(
                  child: ListTileSetting(
                    leadingIcon: Icons.info_outline,
                    subtitleText: appLocalizations.settingAboutDescription,
                    titleText: appLocalizations.settingAbout,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
