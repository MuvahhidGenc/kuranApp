import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/globals/manager/filepath_manager.dart';
import 'package:kuran/globals/manager/network_manager.dart';
import 'package:kuran/view/karikuranmp3/model/kari_kuran_mp3_model.dart';
import 'package:kuran/view/karikuranmp3/view/kari_kuran_mp3_view.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';

class KariKuranMp3ModelView {
  List<dynamic> kariSurahList = List<int>.empty();
  Map<String, Widget> pathStateWidget = Map();
  Map<String, dynamic> audioPathState = Map();
  Map<int, bool> playerControl = Map<int, bool>();
  int say = 0;
  Map<String, dynamic> kari = Map();
  var _sureNameModel = SureNameModel();
  var hafizlar = KariKuranMp3Model();
  String fileName = "hafizlar.json";
  String sureListName = "surelist.json";

  /// Kari List
  dynamic createKariList(Map<String, dynamic> kari) {
    kari["surahs"] != null
        ? kariSurahList = kari["surahs"]!.split(",").map(int.parse).toList()
        : kari["surahs"];

    return kariSurahList;
  }

  int getKariSurahListIndex(Map<String, dynamic> kari) {
    kariSurahList = createKariList(kari);
    var getIndex = kariSurahList.indexOf(kari["surah"]);
    return getIndex;
  }

  String toStringMp3({int? i, bool? url, Map<String, dynamic>? kari}) {
    String surestring = (i! + 1).toString();
    if (surestring.length == 1) {
      surestring = "00" + surestring + ".mp3";
    } else if (surestring.length == 2) {
      surestring = "0" + surestring + ".mp3";
    } else {
      surestring += ".mp3";
    }
    if (url!) {
      return surestring;
    } else {
      // return kariName! + surestring;
      return kari!["name"] + surestring;
    }
  }

  /*Future kariUpdate(
      Map<String, dynamic> kari, SureNameModel sureNameModel) async {
    for (var i = 0; i < sureNameModel.data!.length; i++) {
      String surestring = toStringMp3(i: i, url: false, kari: kari);
      bool pathState = await FilePathManager().getFilePathControl(surestring);

      if (pathState != true) {
        KariKuranMp3View()
        KariKuranMp3View().pathStateWidget[surestring] = Icon(Icons.download);
      }
      audioPathState[surestring] = pathState;
    }
  }*/

  /* Future downloadHafizlar(Map<String, dynamic> kari) async {
    // Get Kari
    String? path = DirectoryNameEnum(DirectoryName.kiraat).getjsonPath;
    dynamic getHafizlar = await NetworkManager().saveStorage(
        url: UrlsConstant.KURAN_MP3_URL, folder: path, fileName: fileName);
    hafizlar = KariKuranMp3Model.fromJson(jsonDecode(jsonDecode(getHafizlar)));

//Get List Surah Names
    var getSureName = await NetworkManager().saveStorage(
        url: UrlsConstant.ACIK_KURAN_URL + "/surahs",
        folder: DirectoryNameEnum(DirectoryName.surenamelist).getjsonPath,
        fileName: sureListName);

    _sureNameModel = SureNameModel.fromJson(jsonDecode(getSureName));
    //_sureNameModel=Sure

    // await kariUpdate(kari);

    _sureNameModel.data!.map((e) async {
      playerControl[say] = false;
      say++;
    }).toList();
  }*/
}
