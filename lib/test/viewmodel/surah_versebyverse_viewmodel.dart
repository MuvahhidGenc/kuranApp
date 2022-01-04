import 'package:flutter/cupertino.dart';
import 'package:kuran/test/view/meal_view.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';
import 'package:kuran/view/trarmp3/modelview/trar_mp3_viewmodel.dart';

class SurahVerseByVerseViewModel extends ChangeNotifier {
  TrArMp3ViewModel _trArViewModel = TrArMp3ViewModel();
  SureNameModel sureNameModel = SureNameModel();
  @override
  // ignore: must_call_super

  getSureName() async {
    sureNameModel = await _trArViewModel.getSureNameModel();
    print(sureNameModel.data!.length);
    notifyListeners();
  }

}
