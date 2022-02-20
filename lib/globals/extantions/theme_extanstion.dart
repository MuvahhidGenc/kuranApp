extension ThemeExtansion on ThemeEnum {
  String? get getThemeName {
    switch (this) {
      case ThemeEnum.dark:
        return "dark";
      case ThemeEnum.light:
        return "light";
    }
  }
}

enum ThemeEnum { light, dark }
