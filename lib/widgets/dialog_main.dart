import 'package:flutter/material.dart';

import 'package:flutter_id_wallet/widgets/dialog_content_add_app.dart';
import 'package:flutter_id_wallet/widgets/dialog_content_add_id.dart';
import 'package:flutter_id_wallet/widgets/dialog_content_authenticate.dart';
import 'package:flutter_id_wallet/widgets/dialog_content_export.dart';
import 'package:flutter_id_wallet/widgets/dialog_content_info.dart';
import 'package:flutter_id_wallet/widgets/dialog_content_set_password.dart';
import 'package:flutter_id_wallet/widgets/dialog_content_add_secret.dart';

class DialogMain extends StatefulWidget {
  final DialogType dialogType;
  final String titleText;
  final ContentWidget contentWidget;
  final List<TextEditingController>? textEditingControllers;
  final Function? onSubmitHandler;
  final String? submitButtonText;
  final String? cancelButtonText;
  final List<Widget>? extraButtons;
  final Function(String?, String?, String?)? onAppDropDownChanged;
  final String? appDropDownInitialValue;
  final String? infoMessage;

  DialogMain({
    required this.dialogType,
    required this.titleText,
    required this.contentWidget,
    this.textEditingControllers,
    this.onSubmitHandler,
    this.submitButtonText = 'Add',
    this.cancelButtonText = 'Close',
    this.onAppDropDownChanged,
    this.appDropDownInitialValue,
    this.extraButtons,
    this.infoMessage,
  });

  @override
  _DialogMainState createState() => _DialogMainState();
}

class _DialogMainState extends State<DialogMain> {
  final _formKey = GlobalKey<FormState>();

  String? _appDropDownError = '';
  bool _hasAppDropDownError = false;

  Widget _getContentWidget() {
    Widget result = DialogContentAddID(formKey: _formKey);

    switch (widget.contentWidget) {
      case ContentWidget.addNewId:
        result = DialogContentAddID(
          appDropDownlInitialValue: widget.appDropDownInitialValue,
          appDropDownSubmitOnError:
              (_appDropDownError != null && _appDropDownError != '')
                  ? true
                  : false,
          formKey: _formKey,
          controllers: widget.textEditingControllers,
          onAppDropDownChanged: widget.onAppDropDownChanged == null
              ? null
              : (String? key, String? value, String? firstItemValue,
                  String? dropdownError) {
                  _hasAppDropDownError = value == firstItemValue;
                  _appDropDownError = dropdownError;

                  widget.onAppDropDownChanged!(key, value, dropdownError);
                },
        );
        break;
      case ContentWidget.addNewApp:
        result = DialogContentAddApp(
          formKey: _formKey,
          controllers: widget.textEditingControllers,
        );
        break;
      case ContentWidget.addSecretKey:
        result = DialogContentAddSecret(
          formKey: _formKey,
          controllers: widget.textEditingControllers,
        );
        break;
      case ContentWidget.setPassword:
        result = DialogContentSetPassword(
          formKey: _formKey,
          controllers: widget.textEditingControllers,
        );
        break;
      case ContentWidget.export:
        result = DialogContentExport(
          controllers: widget.textEditingControllers,
        );
        break;
      case ContentWidget.authenticate:
        result = DialogContentAuthenticate(
          formKey: _formKey,
          controllers: widget.textEditingControllers,
        );
        break;
      case ContentWidget.info:
        result = DialogContentInfo(widget.infoMessage ?? '');
        break;
    }

    return result;
  }

  List<Widget> _getActionWidgets(BuildContext context) {
    List<Widget> result = [];
    List<Widget> actionButtons = [];

    if (widget.dialogType == DialogType.editor) {
      actionButtons.add(TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        child: Text(
          widget.submitButtonText!,
          style: TextStyle(
            fontSize:
                Localizations.localeOf(context).toString().toUpperCase() == 'MY'
                    ? 13.0
                    : null,
          ),
        ),
        onPressed: () {
          if (_hasAppDropDownError) {
            setState(() {
              _appDropDownError = 'ERR';
            });
          }

          if (_formKey.currentState != null &&
              _formKey.currentState!.validate()) {
            if (_appDropDownError != '') {
              return;
            }

            if (widget.onSubmitHandler != null) {
              widget.onSubmitHandler!();
            }
          }
        },
      ));
      actionButtons.add(SizedBox(width: 7.0));
    }

    if (widget.extraButtons != null) {
      for (Widget extraBtn in widget.extraButtons!) {
        actionButtons.add(extraBtn);
        actionButtons.add(SizedBox(width: 7.0));
      }
    }

    actionButtons.add(TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).textTheme.titleLarge!.color,
      ),
      child: Text(
        widget.cancelButtonText!,
        style: TextStyle(
          fontSize:
              Localizations.localeOf(context).toString().toUpperCase() == 'MY'
                  ? 13.0
                  : null,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ));

    Widget resultWidget = SingleChildScrollView(
      child: Row(children: actionButtons),
      scrollDirection: Axis.horizontal,
    );

    result.add(resultWidget);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: _getActionWidgets(context),
      content: Container(
        child: _getContentWidget(),
        width: 300.0,
      ),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      titlePadding: EdgeInsets.all(0.0),
      title: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Theme.of(context).primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            widget.titleText,
            style: TextStyle(
              color: Colors.white,
              fontSize:
                  Localizations.localeOf(context).toString().toUpperCase() ==
                          'MY'
                      ? 16.0
                      : null,
            ),
          ),
        ),
      ),
    );
  }
}

enum ContentWidget {
  addNewId,
  addNewApp,
  addSecretKey,
  setPassword,
  export,
  authenticate,
  info,
}

enum DialogType {
  info,
  editor,
}
