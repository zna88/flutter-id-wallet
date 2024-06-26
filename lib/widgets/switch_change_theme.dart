import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_id_wallet/providers/providers.dart';

class SwitchChangeTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
      activeColor: themeProvider.isDarkMode
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).primaryColor,
      value: themeProvider.isDarkMode,
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
      },
    );
  }
}
