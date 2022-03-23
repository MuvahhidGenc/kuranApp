import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuran/globals/constant/hivedb_constant.dart';
import 'package:kuran/globals/extantions/theme_extanstion.dart';

import '../../extantions/hivedb.dart';

class AppThemeBase extends ChangeNotifier {
  ThemeData? _selectedTheme;

  AppThemeBase({required bool darkMode}) {
    constructorKontrol(darkMode);
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
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.brown.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
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
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.black.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        ),
      ),
    );
  }

  constructorKontrol(bool darkMode) async {
    var themeDb = await HiveDb().getBox(HiveDbConstant.NIGHTMODE);
    if (themeDb == null) {
      _selectedTheme = darkMode == true ? dark : light;
    } else if (themeDb == true) {
      _selectedTheme = dark;
    } else if (themeDb == false) {
      _selectedTheme = light;
    }
    notifyListeners();
  }

  changeStateTheme() {
    if (_selectedTheme == dark) {
      _selectedTheme = light;
      HiveDb().putBox(HiveDbConstant.NIGHTMODE, false);
    } else {
      _selectedTheme = dark;
      HiveDb().putBox(HiveDbConstant.NIGHTMODE, true);
    }

    notifyListeners();
  }

  ThemeData? get getTheme => _selectedTheme;
}
