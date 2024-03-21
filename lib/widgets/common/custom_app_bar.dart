import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;
  final Widget? leadingWidget;
  final List<Widget>? actionsWidget;

  CustomAppBar({
    required this.appBarTitle,
    this.leadingWidget,
    this.actionsWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actionsWidget,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0.0,
      leading: leadingWidget,
      title: Text(appBarTitle),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
