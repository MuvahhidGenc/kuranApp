import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension SnippetExtanstion on BuildContext {
  ThemeData get theme => Theme.of(this);
  MediaQueryData get media => MediaQuery.of(this);
}

enum DirectoryName {
  surahs,
  verses,
  kiraat,
  translition,
  mp3kiraat,
  mealmp3,
  turkcearapcamp3,
  surenamelist
}

extension DirectoryNameEnum on DirectoryName {
  String? get getjsonPath {
    switch (this) {
      case DirectoryName.surahs:
        return "/surahs/";
      case DirectoryName.surenamelist:
        return "/surahNameList/";
      case DirectoryName.verses:
        return "/verses/";
      case DirectoryName.kiraat:
        return "/kiraat/";
      case DirectoryName.translition:
        return "/translition/";
      case DirectoryName.mp3kiraat:
        return "/mp3kiraat/";
      case DirectoryName.mealmp3:
        return "/mealmp3/";
      case DirectoryName.turkcearapcamp3:
        return "/turkcearapcamp3/";
        break;
      default:
    }
  }
}
