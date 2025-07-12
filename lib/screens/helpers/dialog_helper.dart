import 'package:flutter/material.dart';
import 'package:flutter_id_wallet/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:clipboard/clipboard.dart';

import 'package:flutter_id_wallet/models/models.dart';
import 'package:flutter_id_wallet/providers/providers.dart';
import 'package:flutter_id_wallet/widgets/widgets.dart';

class DialogHelper {
  static void showPopupMenu(
    BuildContext context,
    WalletInfo walletInfo,
    AppLocalizations appLocalizations,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    showDialog(
      context: context,
      builder: (_) => CustomPopupMenu(
        items: [
          CustomPopupMenuItem(
            label: appLocalizations.messageCopyParam(appLocalizations.labelId),
            icon: Icons.perm_identity,
            onTap: () {
              FlutterClipboard.copy(walletInfo.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    appLocalizations
                        .messageCopiedParam(appLocalizations.labelId),
                  ),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          CustomPopupMenuItem(
            label: appLocalizations
                .messageCopyParam(appLocalizations.labelPassword),
            icon: Icons.password,
            onTap: () {
              FlutterClipboard.copy(walletInfo.password);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    appLocalizations
                        .messageCopiedParam(appLocalizations.labelPassword),
                  ),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  static void showAddNewIdDialog(
    BuildContext context,
    AppLocalizations appLocalizations, {
    AddNewDialogType addNewDialogType = AddNewDialogType.add,
    WalletInfo? wInfo,
  }) {
    final idController = TextEditingController();
    final passwordController = TextEditingController();

    String appDropDownKey = '';
    String appDropDownValue = '';
    String titleText = appLocalizations.homeAddIdDialogTitle;
    String submitButtonText = appLocalizations.dialogBtnAdd;

    if (addNewDialogType == AddNewDialogType.edit) {
      if (wInfo != null) {
        idController.text = wInfo.id;
        passwordController.text = wInfo.password;
        appDropDownValue = wInfo.appId;
      }

      titleText = appLocalizations.homeEditIdDialogTitle;
      submitButtonText = appLocalizations.dialogBtnUpdate;
    }

    showDialog(
      barrierDismissible: false,
      builder: (_) => DialogMain(
        appDropDownInitialValue:
            appDropDownValue != '' ? appDropDownValue : null,
        contentWidget: ContentWidget.addNewId,
        cancelButtonText: appLocalizations.dialogBtnClose,
        dialogType: DialogType.editor,
        titleText: titleText,
        onAppDropDownChanged: appDropDownValue != ''
            ? null
            : (key, value, dropdownError) {
                appDropDownKey = key!;
                appDropDownValue = value!;
              },
        onSubmitHandler: () {
          final dataProvider =
              Provider.of<DataProvider>(context, listen: false);
          if (addNewDialogType == AddNewDialogType.add) {
            dataProvider.saveWalletInfo(
              appDropDownKey,
              appDropDownValue,
              idController.text,
              passwordController.text,
            );
          } else {
            dataProvider.updateWalletInfo(WalletInfo(
              walletInfoId: wInfo!.walletInfoId,
              appId: wInfo.appId,
              appName: wInfo.appName,
              id: idController.text,
              password: passwordController.text,
              isFavorite: wInfo.isFavorite,
            ));
          }
          Navigator.of(context).pop();
        },
        submitButtonText: submitButtonText,
        textEditingControllers: [
          idController,
          passwordController,
        ],
      ),
      context: context,
    );
  }

  static void showAddNewAppDialog(
      BuildContext context, AppLocalizations appLocalizations) {
    final appNameController = TextEditingController();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => DialogMain(
        cancelButtonText: appLocalizations.dialogBtnClose,
        dialogType: DialogType.editor,
        titleText: appLocalizations.settingApplicationListDialogTitle,
        contentWidget: ContentWidget.addNewApp,
        textEditingControllers: [
          appNameController,
        ],
        onSubmitHandler: () {
          final dataProvider =
              Provider.of<DataProvider>(context, listen: false);
          dataProvider.saveApplication(appNameController.text);
          Navigator.of(context).pop();
        },
        submitButtonText: appLocalizations.dialogBtnAdd,
      ),
    );
  }

  static void showAuthenticateDialog(
    BuildContext context,
    AppLocalizations appLocalizations, [
    Function? successCallback,
  ]) {
    showDialog(
      barrierDismissible: false,
      builder: (_) => DialogMain(
        cancelButtonText: appLocalizations.dialogBtnClose,
        dialogType: DialogType.editor,
        contentWidget: ContentWidget.authenticate,
        onSubmitHandler: () {
          Navigator.of(context).pop();
          if (successCallback != null) successCallback();
        },
        submitButtonText: appLocalizations.dialogBtnAuthenticate,
        titleText: appLocalizations.settingPasswordAuthenticateDialogTitle,
      ),
      context: context,
    );
  }
}

enum AddNewDialogType {
  add,
  edit,
}
