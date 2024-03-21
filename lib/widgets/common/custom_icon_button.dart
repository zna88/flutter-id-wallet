import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_id_wallet/providers/providers.dart';

class CustomIconButton extends StatelessWidget {
  final IconData? leadingIcon;
  final String buttonText;
  final void Function()? onPressed;

  CustomIconButton({
    this.leadingIcon,
    this.buttonText = '',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return TextButton(
      child: Row(
        children: [
          Icon(leadingIcon),
          SizedBox(width: 5.0),
          Text(
            buttonText,
            style: TextStyle(
              fontSize:
                  Localizations.localeOf(context).toString().toUpperCase() ==
                          'MY'
                      ? 13.0
                      : null,
            ),
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: themeProvider.isDarkMode
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).primaryColor,
      ),
    );
  }
}
