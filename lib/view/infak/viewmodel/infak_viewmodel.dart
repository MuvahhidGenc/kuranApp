import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/globals/services/dio/request.dart';
import 'package:kuran/view/infak/model/infak_model.dart';

class InfakViewModel {
  getIhtiyacSahipleri() async {
    var data = await GetPageAPI().getHttp(UrlsConstant.INFAK);
    var dataDecode = InfakModel.fromJson(data);
    return dataDecode;
  }
}
