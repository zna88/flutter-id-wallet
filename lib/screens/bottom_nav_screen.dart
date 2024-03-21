import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_id_wallet/providers/providers.dart';
import 'package:flutter_id_wallet/screens/favorite_screen.dart';
import 'package:flutter_id_wallet/screens/home_screen.dart';
import 'package:flutter_id_wallet/screens/setting_screen.dart';

class BottomNavScreen extends StatefulWidget {
  static const String screenName = '/bottomNavScreen';

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final List<IconData> _menuIcons = [
    Icons.home,
    Icons.favorite,
    Icons.settings,
  ];
  final List<Widget> _screens = [
    HomeScreen(),
    FavoriteScreen(),
    SettingScreen(),
  ];
  int _currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: _screens[_currentScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentScreenIndex,
        onTap: (index) {
          setState(() {
            _currentScreenIndex = index;
          });
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor:
            themeProvider.isDarkMode ? Colors.white : Colors.grey,
        elevation: 0.0,
        items: _menuIcons
            .asMap()
            .map(
              (key, value) => MapEntry(
                key,
                BottomNavigationBarItem(
                  label: '',
                  icon: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 18.0,
                    ),
                    decoration: BoxDecoration(
                      color: _currentScreenIndex == key
                          ? themeProvider.isDarkMode
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Icon(value),
                  ),
                ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }
}
