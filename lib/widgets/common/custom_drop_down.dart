import 'package:flutter/material.dart';
import 'package:flutter_id_wallet/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter_id_wallet/providers/providers.dart';

class CustomDropDown extends StatefulWidget {
  final List<CustomDropDownItem> items;
  final CustomDropDownItem value;
  final void Function(
    CustomDropDownItem?,
    CustomDropDownItem?,
    String?,
  )? onChanged;
  final CustomDropDownItem? firstItemValue;
  final bool isRequiredField;
  final bool submitOnError;

  CustomDropDown({
    required this.items,
    required this.value,
    required this.onChanged,
    this.firstItemValue,
    this.isRequiredField = false,
    this.submitOnError = false,
  });

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String _dropdownError = '';

  @override
  void didUpdateWidget(covariant CustomDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.submitOnError && widget.submitOnError) {
      _dropdownError = AppLocalizations.of(context)!.validationMessageRequired;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);

    if (widget.firstItemValue != null) {
      widget.items.insert(
          0,
          CustomDropDownItem(
            key: widget.firstItemValue!.key,
            value: widget.firstItemValue!.value,
          ));
    }

    return Column(
      children: [
        Container(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CustomDropDownItem>(
              items: widget.items
                  .map(
                    (e) => DropdownMenuItem<CustomDropDownItem>(
                      child: Row(
                        children: [
                          if (widget.firstItemValue == null ||
                              e.key != widget.firstItemValue!.key)
                            CircleAvatar(
                              child: Text(e.value.substring(0, 1)),
                              backgroundColor: themeProvider.isDarkMode
                                  ? Colors.black
                                  : Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              radius: 14.0,
                            ),
                          const SizedBox(width: 8.0),
                          Text(
                            e.value,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      value: e,
                    ),
                  )
                  .toList(),
              onChanged: widget.onChanged == null
                  ? null
                  : (value) {
                      if (widget.isRequiredField) {
                        _dropdownError = '';
                        if (widget.firstItemValue != null &&
                            value!.key == widget.firstItemValue!.key) {
                          setState(() {
                            _dropdownError =
                                appLocalizations!.validationMessageRequired;
                          });
                        }
                      }

                      widget.onChanged!(
                        value,
                        widget.firstItemValue,
                        _dropdownError,
                      );
                    },
              value: widget.value,
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color:
                themeProvider.isDarkMode ? Colors.grey.shade700 : Colors.white,
            border: _dropdownError != '' ? Border.all(color: Colors.red) : null,
          ),
          height: 40.0,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          width: double.infinity,
        ),
        if (_dropdownError != '')
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 7.0),
            child: Text(
              _dropdownError,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.0,
              ),
            ),
          ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

class CustomDropDownItem {
  final String key;
  final String value;

  CustomDropDownItem({
    required this.key,
    required this.value,
  });

  @override
  bool operator ==(Object other) =>
      other is CustomDropDownItem && other.key == key;

  @override
  int get hashCode => key.hashCode;
}
