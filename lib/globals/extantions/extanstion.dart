import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

extension SnippetExtanstion on BuildContext {
  ThemeData get theme => Theme.of(this);
  MediaQueryData get media => MediaQuery.of(this);
  showToast(String msg, {int? duration, int? position}) {
    FlutterToastr.show(msg, this, duration: duration, position: 0);
  }

  
}

enum ExcationManagerEnum{
  notConnection,
  downloadEroor,
}

extension NetworkConnectExtension on ExcationManagerEnum{
  String? get connectionValue{
    switch (this) {
      case ExcationManagerEnum.notConnection :
        return "İnternet Bağlantı Hatası";
      case ExcationManagerEnum.downloadEroor:
        return "İndirme Başarısız Oldu";
    }
  }
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
