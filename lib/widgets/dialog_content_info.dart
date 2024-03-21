import 'package:flutter/material.dart';

class DialogContentInfo extends StatelessWidget {
  final String message;

  DialogContentInfo([this.message = '']);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        message,
        style: TextStyle(
          fontSize:
              Localizations.localeOf(context).toString().toUpperCase() == 'MY'
                  ? 14.0
                  : null,
        ),
      ),
    );
  }
}
