import 'package:flutter/material.dart';
import 'package:flutter_id_wallet/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter_id_wallet/providers/providers.dart';
import 'package:flutter_id_wallet/widgets/widgets.dart';
import 'package:flutter_id_wallet/screens/bottom_nav_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: CustomTextFormField(
                controller: _passwordController,
                customValidationCallback: (value) =>
                    value == dataProvider.appPassword,
                customValidationErrorMessage: appLocalizations!.validationMessageInvalidPassword,
                hitText: appLocalizations.hintTextPassword,
                isPasswordField: true,
                maxTextLength: 30,
                minTextLength: 1,
                onFieldSubmitted: (value) {
                  if (!_formKey.currentState!.validate()) return;

                  setState(() {
                    _isLoading = true;
                  });
                  Future.delayed(Duration(milliseconds: 500)).then((value) {
                    if (_passwordController.text == dataProvider.appPassword) {
                      Navigator.of(context)
                          .pushReplacementNamed(BottomNavScreen.screenName);
                    }
                  });
                },
              ),
            ),
            SizedBox(height: 20.0),
            if (_isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
