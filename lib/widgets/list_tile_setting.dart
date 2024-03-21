import 'package:flutter/material.dart';

class ListTileSetting extends StatelessWidget {
  final IconData? leadingIcon;
  final String subtitleText;
  final String titleText;
  final Widget? trailingWidget;

  ListTileSetting({
    this.leadingIcon,
    this.subtitleText = '',
    this.titleText = '',
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: Theme.of(context).iconTheme.color,
      ),
      subtitle: Text(
        subtitleText,
        style: TextStyle(
          color: Theme.of(context).textTheme.titleLarge!.color,
          fontSize:
              Localizations.localeOf(context).toString().toUpperCase() == 'MY'
                  ? 12.0
                  : null,
        ),
      ),
      title: Text(
        titleText,
        style: TextStyle(
          fontSize:
              Localizations.localeOf(context).toString().toUpperCase() == 'MY'
                  ? 16.0
                  : null,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailingWidget,
    );
  }
}
