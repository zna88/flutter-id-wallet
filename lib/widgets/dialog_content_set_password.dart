import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_id_wallet/widgets/common/custom_text_form_field.dart';

class DialogContentSetPassword extends StatelessWidget {
  final formKey;
  final List<TextEditingController>? controllers;

  DialogContentSetPassword({required this.formKey, this.controllers});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              controller: controllers != null ? controllers![0] : null,
              hitText: appLocalizations!.hintTextPassword,
              isPasswordField: true,
              maxTextLength: 30,
              minTextLength: 1,
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextFormField(
              constraintController:
                  controllers != null ? controllers![0] : null,
              constraintErrorMessage:
                  appLocalizations.validationMessagePasswordNotMatched,
              controller: controllers != null ? controllers![1] : null,
              hitText: appLocalizations.hintTextConfirmPassword,
              isPasswordField: true,
              maxTextLength: 30,
              minTextLength: 1,
            ),
          ],
        ),
      ),
    );
  }
}
