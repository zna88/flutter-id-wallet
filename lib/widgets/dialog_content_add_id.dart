import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter_id_wallet/providers/providers.dart';
import 'package:flutter_id_wallet/widgets/common/custom_text_form_field.dart';
import 'package:flutter_id_wallet/widgets/common/custom_drop_down.dart';

class DialogContentAddID extends StatefulWidget {
  final formKey;
  final List<TextEditingController>? controllers;
  final Function(String?, String?, String?, String?)? onAppDropDownChanged;
  final bool appDropDownSubmitOnError;
  final String? appDropDownlInitialValue;

  DialogContentAddID({
    this.formKey,
    this.controllers,
    this.onAppDropDownChanged,
    this.appDropDownSubmitOnError = false,
    this.appDropDownlInitialValue,
  });

  @override
  _DialogContentAddIDState createState() => _DialogContentAddIDState();
}

class _DialogContentAddIDState extends State<DialogContentAddID> {
  CustomDropDownItem _applicationValue = CustomDropDownItem(
    key: 'SELECT ONE',
    value: 'SELECT ONE',
  );

  @override
  void initState() {
    super.initState();

    if (widget.onAppDropDownChanged != null) {
      widget.onAppDropDownChanged!(
        _applicationValue.key,
        _applicationValue.value,
        _applicationValue.key,
        null,
      );
    }

    if (widget.appDropDownlInitialValue != null) {
      _applicationValue = CustomDropDownItem(
        key: widget.appDropDownlInitialValue!,
        value: widget.appDropDownlInitialValue!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);

    final CustomDropDownItem firstItemValue = CustomDropDownItem(
        key: 'SELECT ONE', value: appLocalizations!.labelSelectOne);

    if (_applicationValue.key == 'SELECT ONE') {
      _applicationValue = CustomDropDownItem(
        key: _applicationValue.key,
        value: appLocalizations.labelSelectOne,
      );
    }

    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            CustomDropDown(
              firstItemValue: firstItemValue,
              isRequiredField: true,
              items: dataProvider.appList.applications
                  .map<CustomDropDownItem>((app) => CustomDropDownItem(
                        key: app.appId,
                        value: app.appName,
                      ))
                  .toList(),
              onChanged: widget.onAppDropDownChanged == null
                  ? null
                  : (CustomDropDownItem? value,
                      CustomDropDownItem? firstItemValue,
                      String? dropdownError) {
                      setState(() {
                        _applicationValue = value!;
                      });

                      widget.onAppDropDownChanged!(
                        value!.key,
                        value.value,
                        firstItemValue!.key,
                        dropdownError,
                      );
                    },
              submitOnError: widget.appDropDownSubmitOnError,
              value: _applicationValue,
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextFormField(
              controller:
                  widget.controllers != null ? widget.controllers![0] : null,
              hitText: appLocalizations.hintTextId,
              minTextLength: 1,
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextFormField(
              controller:
                  widget.controllers != null ? widget.controllers![1] : null,
              hitText: appLocalizations.hintTextPassword,
              isPasswordField: true,
            ),
          ],
        ),
      ),
    );
  }
}
