import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/globals/extantions/hivedb.dart';
import 'package:kuran/globals/manager/network_manager.dart';
import 'package:kuran/test/model/hive_favorilerim_model.dart';
import 'package:kuran/test/model/meal_model.dart';
import 'package:kuran/test/model/singleayah_model.dart';
import 'package:kuran/test/snippet/hive_boxes.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';
import 'package:kuran/view/trarmp3/modelview/trar_mp3_viewmodel.dart';
import 'package:http/http.dart' as http;

class SurahVerseByVerseViewModel extends ChangeNotifier {
  TrArMp3ViewModel _trArViewModel = TrArMp3ViewModel();
  SureNameModel sureNameModel = SureNameModel();
  MealModel mealModel = MealModel();
  List<Verse> ayahs = List.empty();
  String translationFileName = "tanslation";
  AudioPlayer _audioPlayer = AudioPlayer();
  Box<HiveFavorilerimModel>? box;
  @override
  // ignore: must_call_super

  getSureName() async {
    sureNameModel = await _trArViewModel.getSureNameModel();
    notifyListeners();
  }

  getMealDetail({required int surahId}) async {
    var translationPath = await NetworkManager().saveStorage(
        url: UrlsConstant.ACIK_KURAN_URL + "surah/$surahId?author=6",
        fileName: translationFileName + "_$surahId.json",
        folder: "translations");

    mealModel = await MealModel.fromJson(jsonDecode(translationPath));
    return await mealModel.data!.verses!;
    //print(mealModel.data!.verses!.length);
  }

  getAyahAudio({required int surahNo, required int ayahNo}) async {
    final response = await http.get(Uri.parse(
        UrlsConstant.ALQURANCLOUDV1 + "ayah/$surahNo:$ayahNo/ar.alafasy"));
    if (response.statusCode == 200) {
      Map<String, dynamic> decode = jsonDecode(response.body);
      var get = AyahModel.fromJson(decode);
      return get.data!.audioSecondary![2];
    } else {
      return "hata";
    }
  }

  playUrlSingleAyah({required String url}) {
    _audioPlayer.play(url);
  }

  stopAudio() {
    _audioPlayer.stop();
  }

  isFavoriControl({required int surahNo, required int ayahNo}) {
    box = HiveBoxes.faroviAyetlerimBox();

    if (box != null) {
      //  print(box!.keys);
      for (var value in box!.values) {
        if (surahNo == value.surahNo && ayahNo == value.ayahNo) {
          // print("$surahNo - ${value.surahNo} / $ayahNo - ${value.ayahNo}");
          return true;
        }
      }
    }

    return false;

    //return box!.containsKey(index);
  }

  Future<bool> isFavori({required int surahNo, required int ayahNo}) async {
    box = HiveBoxes.faroviAyetlerimBox();

    if (box != null) {
      for (var key in box!.keys) {
        if (box!.containsKey(key)) {
          var get = box!.get(key);
          if (get?.ayahNo == ayahNo && get?.surahNo == surahNo) {
            box!.delete(key);
            return true;
          }
        }
      }
    }
    return false;

    //return false;

    //return box!.containsKey(index);
  }
}
