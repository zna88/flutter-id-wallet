import 'package:flutter/material.dart';

import 'package:flutter_id_wallet/widgets/common/custom_text_form_field.dart';

class DialogContentExport extends StatelessWidget {
  final List<TextEditingController>? controllers;

  DialogContentExport({this.controllers});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: CustomTextFormField(
          controller: controllers != null ? controllers![0] : null,
          isReadOnly: true,
          maxLines: 10,
        ),
      ),
    );
  }
}
