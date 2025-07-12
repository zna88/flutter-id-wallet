import 'package:flutter/material.dart';
import 'package:flutter_id_wallet/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter_id_wallet/providers/providers.dart';
import 'package:flutter_id_wallet/widgets/widgets.dart';
import 'package:flutter_id_wallet/screens/helpers/dialog_helper.dart';
import 'package:flutter_id_wallet/screens/helpers/message_helper.dart';

class PasswordScreen extends StatelessWidget {
  static const String screenName = '/passwordScreen';
  void _showSetPasswordDialog(
    BuildContext context,
    AppLocalizations appLocalizations, {
    SetPasswordDialogType setPasswordDialogType = SetPasswordDialogType.add,
  }) {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    String titleText = appLocalizations.settingPasswordAdd;
    String submitButtonText = appLocalizations.dialogBtnSave;
    String snackBarMessage = appLocalizations.messagePasswordAdded;

    if (setPasswordDialogType == SetPasswordDialogType.edit) {
      titleText = appLocalizations.settingPasswordChange;
      submitButtonText = appLocalizations.dialogBtnUpdate;
      snackBarMessage = appLocalizations.messagePasswordChange;
    }

    showDialog(
      barrierDismissible: false,
      builder: (_) => DialogMain(
        cancelButtonText: appLocalizations.dialogBtnClose,
        contentWidget: ContentWidget.setPassword,
        dialogType: DialogType.editor,
        onSubmitHandler: () {
          final dataProvider =
              Provider.of<DataProvider>(context, listen: false);
          dataProvider.saveAppPassword(confirmPasswordController.text);
          Navigator.of(context).pop();
          MessageHelper.showSnackBarMessage(
            context,
            snackBarMessage,
            displayDuration: Duration(seconds: 1),
          );
        },
        submitButtonText: submitButtonText,
        textEditingControllers: [
          passwordController,
          confirmPasswordController,
        ],
        titleText: titleText,
      ),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    Provider.of<DataProvider>(context, listen: false).loadAppPassword();
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: appLocalizations!.settingPasswordTitle,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InkWell(
                  child: ListTileSetting(
                    leadingIcon: Icons.password,
                    subtitleText: dataProvider.hasPassword
                        ? appLocalizations.settingPasswordChangeDescription
                        : appLocalizations.settingPasswordAddDescription,
                    titleText: dataProvider.hasPassword
                        ? appLocalizations.settingPasswordChange
                        : appLocalizations.settingPasswordAdd,
                  ),
                  onTap: () {
                    if (dataProvider.hasPassword) {
                      DialogHelper.showAuthenticateDialog(
                        context,
                        appLocalizations,
                        () {
                          _showSetPasswordDialog(
                            context,
                            appLocalizations,
                            setPasswordDialogType: SetPasswordDialogType.edit,
                          );
                        },
                      );
                    } else {
                      _showSetPasswordDialog(context, appLocalizations);
                    }
                  },
                ),
                Divider(),
                if (dataProvider.hasPassword)
                  InkWell(
                    child: ListTileSetting(
                      leadingIcon: Icons.delete_forever,
                      subtitleText:
                          appLocalizations.settingPasswordDeleteDescription,
                      titleText: appLocalizations.settingPasswordDelete,
                    ),
                    onTap: () {
                      DialogHelper.showAuthenticateDialog(
                        context,
                        appLocalizations,
                        () {
                          Provider.of<DataProvider>(context, listen: false)
                              .saveAppPassword('');
                          MessageHelper.showSnackBarMessage(
                            context,
                            appLocalizations.messagePasswordDelete,
                            displayDuration: Duration(seconds: 1),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum SetPasswordDialogType {
  add,
  edit,
}
