import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/globals/extantions/hivedb.dart';
import 'package:kuran/globals/manager/filepath_manager.dart';
import 'package:kuran/globals/manager/network_manager.dart';
import 'package:kuran/view/karikuranmp3/model/kari_kuran_mp3_model.dart';
import 'package:kuran/view/karikuranmp3/view/kari_kuran_mp3_view.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';
import 'package:kuran/view/kuran/modelview/kuran_model_view.dart';

class TestKariKuranMp3ModelView {
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  PlayerState _audioPlayerState = PlayerState.STOPPED;
  Map<String, bool> audioPathState = Map<String, bool>();

  Map<String, dynamic> hiveKey = {
    "kariId": "kariId",
    "kariName": "kariName",
    "kariUrl": "kariUrl",
    "kariSurahs": "kariSurahs"
  };
  List<dynamic> kariSurahList = List<int>.empty();
  Map<String, Widget> pathStateWidget =
      Map<String, Widget>(); //List Tile Path State Control And
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

  Future initAsyc() async {
    dynamic v = KuranModelView().dbKeyControl(hiveKey["kariUrl"]);
    if (v == null) {
      HiveDb().putBox(hiveKey["kariUrl"], "https://server7.mp3quran.net/basit");
      HiveDb().putBox(hiveKey["kariName"], "Abdulbasit Abdulsamad");
      HiveDb().putBox(hiveKey["kariSurahs"],
          "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114");
      kari["name"] = await HiveDb().getBox(hiveKey["kariName"]);
      kari["surahs"] = await HiveDb().getBox(hiveKey["kariSurahs"]);
    } else {
      kari["name"] = await HiveDb().getBox(hiveKey["kariName"]);
      kari["surahs"] = await HiveDb().getBox(hiveKey["kariSurahs"]);

      kari;
      kari["name"].toString().toLowerCase().trim();
      // kariSurahs;
      // kariName!.toLowerCase().trim();
    }
    // _kariKuranMp3ModelView.downloadHafizlar(kari);
    downloadHafizlar();
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

  Future kariUpdate() async {
    for (var i = 0; i < _sureNameModel.data!.length; i++) {
      String surestring = toStringMp3(i: i, url: false, kari: kari);
      bool pathState = await FilePathManager().getFilePathControl(surestring);

      if (pathState != true) {
        pathStateWidget[surestring] = Icon(Icons.download);
      }
      audioPathState[surestring] = pathState;
    }
  }

  Future downloadHafizlar() async {
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
  }

  get getKari {
    initAsyc();
    return kari;
  }

  get getHafizlar {
    downloadHafizlar();
    return hafizlar;
  }

  get getsuraNameModel {
    downloadHafizlar();
    return _sureNameModel;
  }

  get getPlayerControl {
    downloadHafizlar();
    return playerControl;
  }

  get getPathStateWidget {
    return pathStateWidget;
  }

  get getAudioPathState {
    return audioPathState;
  }
}
