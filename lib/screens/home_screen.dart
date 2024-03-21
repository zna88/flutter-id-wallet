import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter_id_wallet/models/models.dart';
import 'package:flutter_id_wallet/providers/providers.dart';
import 'package:flutter_id_wallet/widgets/widgets.dart';
import 'package:flutter_id_wallet/screens/helpers/dialog_helper.dart';
import 'package:flutter_id_wallet/screens/helpers/message_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CustomDropDownItem _applicationValue = CustomDropDownItem(
    key: 'ALL IDs',
    value: 'ALL IDs',
  );

  Widget _buildHeader(
      DataProvider dataProvider, AppLocalizations appLocalizations) {
    final CustomDropDownItem firstItemValue = CustomDropDownItem(
      key: 'ALL IDs',
      value: appLocalizations.labelAllId,
    );

    if (_applicationValue.key == 'ALL IDs') {
      _applicationValue = CustomDropDownItem(
        key: _applicationValue.key,
        value: appLocalizations.labelAllId,
      );
    }

    return Container(
      child: CustomDropDown(
        firstItemValue: firstItemValue,
        items: dataProvider.appList.applications
            .map<CustomDropDownItem>((app) => CustomDropDownItem(
                  key: app.appId,
                  value: app.appName,
                ))
            .toList(),
        value: _applicationValue,
        onChanged: (
          CustomDropDownItem? value,
          CustomDropDownItem? firstItemValue,
          String? dropdownError,
        ) {
          setState(() {
            _applicationValue = value!;
          });
        },
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
        color: Theme.of(context).primaryColor,
      ),
      padding: const EdgeInsets.all(20.0),
    );
  }

  Widget _buildBody(
    DataProvider dataProvider,
    ThemeProvider themeProvider,
    AppLocalizations appLocalizations,
  ) {
    return Expanded(
      child: dataProvider.walletInfoList.walletInfoList.isEmpty
          ? Center(
              child: Text(appLocalizations.messageNoRecord),
            )
          : ListView.builder(
              itemBuilder: (_, index) {
                WalletInfo walletInfo =
                    dataProvider.walletInfoList.walletInfoList[index];

                return Dismissible(
                  background: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      padding: const EdgeInsets.only(left: 18.0),
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
                        trailing: walletInfo.canDecrypt
                            ? IconButton(
                                icon: Icon(
                                  walletInfo.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: themeProvider.isDarkMode
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  dataProvider
                                      .toggleFavorite(walletInfo.walletInfoId);
                                },
                              )
                            : null,
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

                    if (direction == DismissDirection.startToEnd) {
                      DialogHelper.showAddNewIdDialog(
                        context,
                        appLocalizations,
                        addNewDialogType: AddNewDialogType.edit,
                        wInfo: walletInfo,
                      );
                      return false;
                    }

                    return true;
                  },
                  key: UniqueKey(),
                  onDismissed: (DismissDirection direction) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();

                    if (direction == DismissDirection.endToStart) {
                      Provider.of<DataProvider>(context, listen: false)
                          .deleteWalletInfo(walletInfo.walletInfoId);

                      MessageHelper.showSnackBarMessage(
                        context,
                        appLocalizations.messageDeleteParam(
                            '${walletInfo.appName} (${walletInfo.id})'),
                        actionLabel: appLocalizations.messageUndo,
                        actionOnPressed: () {
                          Provider.of<DataProvider>(context, listen: false)
                              .undoDeleteWalletInfo(index, walletInfo);
                        },
                      );
                    }
                  },
                  secondaryBackground: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      color: Colors.red,
                      padding: const EdgeInsets.only(right: 18.0),
                    ),
                  ),
                );
              },
              itemCount: dataProvider.walletInfoList.walletInfoList.length,
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<DataProvider>(context, listen: false).loadApplicationList();
    Provider.of<DataProvider>(context, listen: false).loadSecretKey();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? appLocalizations = AppLocalizations.of(context);
    Provider.of<DataProvider>(context, listen: false).loadWalletInfoList(
        appId: _applicationValue.key.toLowerCase() == 'all ids'
            ? ''
            : _applicationValue.key);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        actionsWidget: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              DialogHelper.showAddNewIdDialog(context, appLocalizations!);
            },
          ),
        ],
        appBarTitle: appLocalizations!.homeScreenTitle,
        leadingWidget: Icon(Icons.home),
      ),
      body: Column(
        children: [
          _buildHeader(dataProvider, appLocalizations),
          SizedBox(height: 5.0),
          _buildBody(dataProvider, themeProvider, appLocalizations),
        ],
      ),
    );
  }
}
