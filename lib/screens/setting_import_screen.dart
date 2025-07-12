import 'package:flutter/material.dart';
import 'package:flutter_id_wallet/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter_id_wallet/models/models.dart';
import 'package:flutter_id_wallet/providers/providers.dart';
import 'package:flutter_id_wallet/widgets/widgets.dart';
import 'package:flutter_id_wallet/screens/helpers/message_helper.dart';

class SettingImportScreen extends StatelessWidget {
  static const String screenName = '/settingImportScreen';

  final _importDataController = TextEditingController();

  void _showImportDialog(
    BuildContext context,
    DataProvider dataProvider,
    AppLocalizations appLocalizations,
    AppData importedAppData,
  ) {
    showDialog(
      barrierColor: Colors.black26,
      barrierDismissible: false,
      context: context,
      builder: (_) => DialogMain(
        cancelButtonText: appLocalizations.dialogBtnCancel,
        contentWidget: ContentWidget.info,
        dialogType: DialogType.info,
        extraButtons: [
          CustomIconButton(
            buttonText: appLocalizations.dialogBtnMerge,
            leadingIcon: Icons.merge_type,
            onPressed: () {
              dataProvider.mergeAppData(importedAppData).then(
                (value) {
                  _importDataController.text = '';
                  Navigator.of(context).pop();
                  MessageHelper.showSnackBarMessage(
                    context,
                    appLocalizations.messageMergeDone,
                    displayDuration: Duration(seconds: 1),
                  );
                },
              );
            },
          ),
          CustomIconButton(
            buttonText: appLocalizations.dialogBtnOverwrite,
            leadingIcon: Icons.find_replace,
            onPressed: () {
              dataProvider.overwriteAppData(importedAppData).then(
                (value) {
                  _importDataController.text = '';
                  Navigator.of(context).pop();
                  MessageHelper.showSnackBarMessage(
                    context,
                    appLocalizations.messageOverwriteDone,
                    displayDuration: Duration(seconds: 1),
                  );
                },
              );
            },
          ),
        ],
        infoMessage: appLocalizations.messageDataConflict,
        titleText: appLocalizations.settingImport,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        actionsWidget: [
          IconButton(
            icon: Icon(Icons.upload),
            onPressed: () {
              final DataProvider dataProvider =
                  Provider.of<DataProvider>(context, listen: false);
              AppData? appData =
                  dataProvider.getImportedAppData(_importDataController.text);

              if (appData == null) {
                MessageHelper.showSnackBarMessage(
                  context,
                  appLocalizations!.messageInvalidData,
                  displayDuration: Duration(seconds: 1),
                );
                return;
              }

              if (dataProvider.appListCount > 0 ||
                  dataProvider.walletInfoListCount > 0) {
                _showImportDialog(
                  context,
                  dataProvider,
                  appLocalizations!,
                  appData,
                );
              } else {
                dataProvider.overwriteAppData(appData).then(
                  (value) {
                    _importDataController.text = '';
                    MessageHelper.showSnackBarMessage(
                      context,
                      appLocalizations!.messageImportDataDone,
                      displayDuration: Duration(seconds: 1),
                    );
                  },
                );
              }
            },
          ),
        ],
        appBarTitle: appLocalizations!.settingImport,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: CustomTextFormField(
                controller: _importDataController,
                hitText: appLocalizations.hintTextImportData,
                maxLines: 30,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}
