import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuran/globals/extantions/theme_extanstion.dart';

class AppThemeBase extends ChangeNotifier {
  ThemeData? _selectedTheme;

  AppThemeBase({required bool darkMode}) {
    _selectedTheme = darkMode == true ? dark : light;
  }

  ThemeData get light {
    return ThemeData(
      primaryColorLight: Colors.black,
      brightness: Brightness.light,
      primarySwatch: Colors.brown,
      primaryColor: Colors.brown,
      scaffoldBackgroundColor: Colors.brown[100],
      listTileTheme: ListTileThemeData(
        tileColor: Colors.brown[300],
        textColor: Colors.brown[50],
        iconColor: Colors.brown[50],
      ),
      drawerTheme: DrawerThemeData(backgroundColor: Colors.brown[100]),
      iconTheme: IconThemeData(color: Colors.brown),
      //colorScheme: ColorScheme(primary: primary, primaryVariant: primaryVariant, secondary: secondary, secondaryVariant: secondaryVariant, surface: surface, background: background, error: error, onPrimary: onPrimary, onSecondary: onSecondary, onSurface: onSurface, onBackground: onBackground, onError: onError, brightness: brightness)
      //accentIconTheme: ColorScheme(primary: primary, primaryVariant: primaryVariant, secondary: secondary, secondaryVariant: secondaryVariant, surface: surface, background: background, error: error, onPrimary: onPrimary, onSecondary: onSecondary, onSurface: onSurface, onBackground: onBackground, onError: onError, brightness: brightness),
    );
  }

  ThemeData get dark {
    return ThemeData.dark().copyWith(
      primaryColorLight: Colors.white,
    );
  }

  changeStateTheme() {
    _selectedTheme = _selectedTheme == dark ? light : dark;
    notifyListeners();
  }

  ThemeData? get getTheme => _selectedTheme;
}
