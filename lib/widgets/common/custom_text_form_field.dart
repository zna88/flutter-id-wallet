import 'package:flutter/material.dart';
import 'package:flutter_id_wallet/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter_id_wallet/providers/providers.dart';

class CustomTextFormField extends StatefulWidget {
  final String? hitText;
  final bool isPasswordField;
  final bool isReadOnly;
  final TextEditingController? controller;
  final int maxLines;
  final int? minTextLength;
  final int? fixedTextLength;
  final int? maxTextLength;
  final Function(String)? onFieldSubmitted;
  final TextEditingController? constraintController;
  final String? constraintErrorMessage;
  final bool Function(String?)? customValidationCallback;
  final String? customValidationErrorMessage;

  CustomTextFormField({
    this.hitText,
    this.isPasswordField = false,
    this.isReadOnly = false,
    this.controller,
    this.maxLines = 1,
    this.minTextLength,
    this.fixedTextLength,
    this.maxTextLength,
    this.onFieldSubmitted,
    this.constraintController,
    this.constraintErrorMessage,
    this.customValidationCallback,
    this.customValidationErrorMessage,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isDisplayPassword = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        contentPadding: !widget.isPasswordField
            ? EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0)
            : EdgeInsets.only(left: 20.0),
        errorStyle: TextStyle(
          fontSize: 12.0,
        ),
        fillColor: themeProvider.isDarkMode
            ? Theme.of(context).inputDecorationTheme.fillColor
            : Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
              color: themeProvider.isDarkMode ? Colors.white : Colors.black),
        ),
        hintText: widget.hitText,
        hintStyle: TextStyle(
          fontSize:
              Localizations.localeOf(context).toString().toUpperCase() == 'MY'
                  ? 14.0
                  : null,
        ),
        suffixIcon: widget.isPasswordField
            ? IconButton(
                color: _isDisplayPassword
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey,
                icon: Icon(_isDisplayPassword
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isDisplayPassword = !_isDisplayPassword;
                  });
                },
              )
            : null,
      ),
      keyboardType: widget.maxLines > 1 && !widget.isPasswordField
          ? TextInputType.multiline
          : TextInputType.text,
      maxLength: widget.maxTextLength,
      maxLines: !widget.isPasswordField ? widget.maxLines : 1,
      obscureText: (widget.isPasswordField && !_isDisplayPassword),
      onFieldSubmitted: widget.onFieldSubmitted,
      readOnly: widget.isReadOnly,
      validator: widget.minTextLength != null || widget.fixedTextLength != null
          ? (value) {
              if (widget.fixedTextLength != null) {
                if (value!.isEmpty == false &&
                    value.length != widget.fixedTextLength) {
                  return appLocalizations!.validationMessageFixedLengthParam(
                      widget.fixedTextLength.toString());
                }
              }

              if (widget.minTextLength != null) {
                if (value == null || value.isEmpty) {
                  return appLocalizations!.validationMessageRequired;
                }

                if (value.length < widget.minTextLength!) {
                  return appLocalizations!.validationMessageMinLengthParam(
                      widget.minTextLength.toString());
                }
              }

              if (widget.constraintController != null &&
                  widget.constraintController!.text != value) {
                return widget.constraintErrorMessage ?? '';
              }

              if (widget.customValidationCallback != null) {
                if (!widget.customValidationCallback!(value)) {
                  return widget.customValidationErrorMessage ?? null;
                }
              }

              return null;
            }
          : null,
    );
  }
}
