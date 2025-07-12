import 'package:flutter/material.dart';
import 'package:flutter_id_wallet/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter_id_wallet/providers/providers.dart';
import 'package:flutter_id_wallet/widgets/common/custom_text_form_field.dart';

class DialogContentAuthenticate extends StatelessWidget {
  final formKey;
  final List<TextEditingController>? controllers;

  DialogContentAuthenticate({required this.formKey, this.controllers});

  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return Container(
      child: Column(
        children: [
          Text(
            appLocalizations!.settingPasswordAuthenticateDialogLabel,
            style: TextStyle(
              fontSize:
                  Localizations.localeOf(context).toString().toUpperCase() ==
                          'MY'
                      ? 12.0
                      : 15.0,
            ),
          ),
          SizedBox(height: 20.0),
          Form(
            child: CustomTextFormField(
              controller: controllers != null ? controllers![0] : null,
              customValidationCallback: (value) =>
                  value == dataProvider.appPassword,
              customValidationErrorMessage:
                  appLocalizations.validationMessageInvalidPassword,
              hitText: appLocalizations.hintTextCurrentPassword,
              isPasswordField: true,
              minTextLength: 1,
              maxTextLength: 30,
            ),
            key: formKey,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}
