import 'package:flutter/material.dart';
import 'package:flutter_id_wallet/l10n/app_localizations.dart';

import 'package:flutter_id_wallet/widgets/common/custom_text_form_field.dart';

class DialogContentAddSecret extends StatelessWidget {
  final formKey;
  final List<TextEditingController>? controllers;

  DialogContentAddSecret({required this.formKey, this.controllers});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return Container(
      child: Column(
        children: [
          Text(
            appLocalizations!.settingSecretKeyDialogLabel,
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
            key: formKey,
            child: CustomTextFormField(
              controller: controllers != null ? controllers![0] : null,
              hitText: appLocalizations.hintTextSecretKey,
              isPasswordField: true,
              maxTextLength: 50,
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}
