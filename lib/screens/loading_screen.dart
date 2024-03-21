import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_id_wallet/providers/providers.dart';
import 'package:flutter_id_wallet/repos/local_storage_settings.dart';
import 'package:flutter_id_wallet/screens/bottom_nav_screen.dart';
import 'package:flutter_id_wallet/screens/login_screen.dart';

class LoadingScreen extends StatelessWidget {
  static const String screenName = '/';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocalStorageSettings.isStorageReady,
      builder: (_, snapshot) {
        Provider.of<DataProvider>(context, listen: false).loadAppPassword();
        final DataProvider dataProvider = Provider.of<DataProvider>(context);

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (dataProvider.hasPassword) {
          return LoginScreen();
        }

        return BottomNavScreen();
      },
    );
  }
}
