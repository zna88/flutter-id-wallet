import 'package:flutter/material.dart';
import 'package:flutter_id_wallet/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter_id_wallet/models/models.dart';
import 'package:flutter_id_wallet/providers/providers.dart';
import 'package:flutter_id_wallet/widgets/widgets.dart';
import 'package:flutter_id_wallet/screens/helpers/dialog_helper.dart';
import 'package:flutter_id_wallet/screens/helpers/message_helper.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<DataProvider>(context, listen: false)
        .loadWalletInfoList(isFavoriteOnly: true);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dataProvider = Provider.of<DataProvider>(context);
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: appLocalizations!.favoriteScreenTitle,
        leadingWidget: Icon(Icons.favorite),
      ),
      body: Container(
        child: dataProvider.walletInfoList.walletInfoList.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(appLocalizations.messageNoRecord),
                ),
              )
            : ListView.builder(
                itemBuilder: (_, index) {
                  WalletInfo walletInfo =
                      dataProvider.walletInfoList.walletInfoList[index];

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
                    child: InkWell(
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: themeProvider.isDarkMode
                                ? Colors.black
                                : Theme.of(context).primaryColor,
                            child: walletInfo.canDecrypt
                                ? Text(walletInfo.appName.substring(0, 1))
                                : Icon(Icons.lock),
                            foregroundColor: Colors.white,
                          ),
                          subtitle: walletInfo.canDecrypt
                              ? Text(walletInfo.id)
                              : Text(
                                  appLocalizations.labelLockedDescription,
                                  style: TextStyle(
                                    fontSize: Localizations.localeOf(context)
                                                .toString()
                                                .toUpperCase() ==
                                            'MY'
                                        ? 11.0
                                        : null,
                                  ),
                                ),
                          title: walletInfo.canDecrypt
                              ? Text(walletInfo.appName)
                              : Text(
                                  appLocalizations.labelLockedTitle,
                                  style: TextStyle(
                                    fontSize: Localizations.localeOf(context)
                                                .toString()
                                                .toUpperCase() ==
                                            'MY'
                                        ? 14.0
                                        : null,
                                  ),
                                ),
                        ),
                      ),
                      onLongPress: walletInfo.canDecrypt
                          ? () => DialogHelper.showPopupMenu(
                                context,
                                walletInfo,
                                appLocalizations,
                              )
                          : null,
                    ),
                    confirmDismiss: (DismissDirection direction) async {
                      if (!walletInfo.canDecrypt) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        MessageHelper.showSnackBarMessage(
                          context,
                          appLocalizations.messageNotAbleToDoAnyAction,
                          displayDuration: Duration(seconds: 1),
                        );
                        return false;
                      }
                      return true;
                    },
                    direction: DismissDirection.endToStart,
                    key: UniqueKey(),
                    onDismissed: (DismissDirection direction) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      Provider.of<DataProvider>(context, listen: false)
                          .toggleFavorite(walletInfo.walletInfoId);
                      MessageHelper.showSnackBarMessage(
                        context,
                        appLocalizations.messageRemoveFavoriteParam(
                            '${walletInfo.appName} (${walletInfo.id})'),
                        actionLabel: appLocalizations.messageUndo,
                        actionOnPressed: () {
                          Provider.of<DataProvider>(context, listen: false)
                              .toggleFavorite(walletInfo.walletInfoId);
                        },
                      );
                    },
                  );
                },
                itemCount: dataProvider.walletInfoList.walletInfoList.length,
              ),
        margin: EdgeInsets.only(top: 5.0),
      ),
    );
  }
}
