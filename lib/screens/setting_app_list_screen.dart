import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter_id_wallet/models/models.dart';
import 'package:flutter_id_wallet/providers/providers.dart';
import 'package:flutter_id_wallet/widgets/widgets.dart';
import 'package:flutter_id_wallet/screens/helpers/dialog_helper.dart';
import 'package:flutter_id_wallet/screens/helpers/message_helper.dart';

class SettingAppListScreen extends StatelessWidget {
  static const String screenName = '/settingAppListScreen';

  @override
  Widget build(BuildContext context) {
    Provider.of<DataProvider>(context, listen: false).loadApplicationList();
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dataProvider = Provider.of<DataProvider>(context);
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
          actionsWidget: [
            IconButton(
              onPressed: () {
                DialogHelper.showAddNewAppDialog(context, appLocalizations!);
              },
              icon: Icon(Icons.add),
            ),
          ],
          appBarTitle: appLocalizations!.settingApplicationListTitle,
          leadingWidget: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.of(context).pop();
            },
          )),
      body: Container(
        child: dataProvider.appList.applications.isEmpty
            ? Center(
                child: Text(appLocalizations.messageNoRecord),
              )
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  final Application oldApp =
                      dataProvider.appList.applications[index];

                  return Dismissible(
                    background: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        color: Colors.red,
                        padding: const EdgeInsets.only(right: 20.0),
                      ),
                    ),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: themeProvider.isDarkMode
                              ? Colors.black
                              : Theme.of(context).primaryColor,
                          child:
                              Text(oldApp.appName.toString().substring(0, 1)),
                          foregroundColor: Colors.white,
                        ),
                        title: Text(oldApp.appName),
                      ),
                    ),
                    confirmDismiss: (DismissDirection direction) async {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      bool result =
                          Provider.of<DataProvider>(context, listen: false)
                              .deleteApplication(oldApp.appId);

                      if (!result) {
                        MessageHelper.showSnackBarMessage(
                          context,
                          appLocalizations.messageNoDeleteParam(oldApp.appName),
                        );
                      }

                      return result;
                    },
                    direction: DismissDirection.endToStart,
                    key: UniqueKey(),
                    onDismissed: (DismissDirection direction) {
                      MessageHelper.showSnackBarMessage(
                        context,
                        appLocalizations.messageDeleteParam(oldApp.appName),
                        actionLabel: appLocalizations.messageUndo,
                        actionOnPressed: () {
                          Provider.of<DataProvider>(context, listen: false)
                              .undoDeleteApplication(index, oldApp);
                        },
                      );
                    },
                  );
                },
                itemCount: dataProvider.appList.applications.length,
              ),
        margin: EdgeInsets.only(top: 5.0),
      ),
    );
  }
}
