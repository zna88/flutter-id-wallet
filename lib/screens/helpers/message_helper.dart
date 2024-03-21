import 'package:flutter/material.dart';

class MessageHelper {
  static void showSnackBarMessage(
    BuildContext context,
    String message, {
    String actionLabel = '',
    Function? actionOnPressed,
    Duration? displayDuration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      action: actionLabel != ''
          ? SnackBarAction(
              label: actionLabel,
              onPressed: () {
                if (actionOnPressed != null) actionOnPressed();
              },
            )
          : null,
      content: Text(
        message,
        style: TextStyle(
          fontSize:
              Localizations.localeOf(context).toString().toUpperCase() == 'MY'
                  ? 12.0
                  : null,
        ),
      ),
      duration: displayDuration ?? Duration(milliseconds: 4000),
    ));
  }
}
