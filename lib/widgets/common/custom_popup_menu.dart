import 'package:flutter/material.dart';

class CustomPopupMenu extends StatelessWidget {
  final List<CustomPopupMenuItem> items;

  CustomPopupMenu({required this.items});

  static void show(BuildContext context, List<CustomPopupMenuItem> items) {
    showDialog(
      context: context,
      builder: (_) => CustomPopupMenu(items: items),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: items
            .map(
              (item) => Column(
                children: [
                  InkWell(
                    child: Container(
                      child: Row(
                        children: [
                          Icon(item.icon),
                          SizedBox(width: 10.0),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: Localizations.localeOf(context)
                                          .toString()
                                          .toUpperCase() ==
                                      'MY'
                                  ? 14.0
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(15.0),
                      width: double.infinity,
                    ),
                    onTap: () {
                      if (item.onTap != null) item.onTap!();
                      Navigator.of(context).pop();
                    },
                  ),
                  Divider(height: 0.0),
                ],
              ),
            )
            .toList(),
        mainAxisSize: MainAxisSize.min,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class CustomPopupMenuItem {
  final String label;
  final IconData icon;
  final Function? onTap;

  CustomPopupMenuItem({
    required this.label,
    required this.icon,
    this.onTap,
  });
}
