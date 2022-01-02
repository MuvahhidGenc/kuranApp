import 'package:get/get.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';
import 'package:kuran/view/trarmp3/modelview/trar_mp3_viewmodel.dart';

class SurahVerseByVerseViewModel extends GetxController {
  TrArMp3ViewModel _trArViewModel = TrArMp3ViewModel();
  SureNameModel sureNameModel = SureNameModel();
  RxMap<String, dynamic> sureNames = RxMap();
  @override
  // ignore: must_call_super
  onInit() {
    getSureName();
  }

  getSureName() async {
    sureNameModel = await _trArViewModel.getSureNameModel();
    print(sureNameModel);
  }
}
