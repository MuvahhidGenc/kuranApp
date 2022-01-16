import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/globals/manager/network_manager.dart';
import 'package:kuran/test/model/meal_model.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';
import 'package:kuran/view/trarmp3/modelview/trar_mp3_viewmodel.dart';

class SurahVerseByVerseViewModel extends ChangeNotifier {
  TrArMp3ViewModel _trArViewModel = TrArMp3ViewModel();
  SureNameModel sureNameModel = SureNameModel();
  MealModel mealModel = MealModel();
  List<Verse> ayahs = List.empty();
  String translationFileName = "tanslation";
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
}
