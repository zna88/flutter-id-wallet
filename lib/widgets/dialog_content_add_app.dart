import 'package:flutter/material.dart';
import 'package:flutter_id_wallet/l10n/app_localizations.dart';

import 'package:flutter_id_wallet/widgets/common/custom_text_form_field.dart';

class DialogContentAddApp extends StatelessWidget {
  final formKey;
  final List<TextEditingController>? controllers;

  DialogContentAddApp({required this.formKey, this.controllers});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: controllers != null ? controllers![0] : null,
                  hitText: appLocalizations!.hintTextAppName,
                  minTextLength: 1,
                  maxTextLength: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
