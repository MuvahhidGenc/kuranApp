import 'dart:convert';
import 'dart:developer';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/globals/extantions/urlpath_extanstion.dart';
import 'package:kuran/test/model/followquran_model.dart';

class FollowQuranViewModel extends ChangeNotifier {
  var _arabicNumber= ArabicNumbers();
  var _arabicNumberConvert;
  getPage({required int pageNo, required String kariId}) async {
    final response = await http.get(Uri.parse(UrlsConstant.ALQURANCLOUDV1 +
        UrlPathExtanstion(URLAlQuranPath.page).urlPath! +
        "$pageNo/$kariId"));
    if (response.statusCode == 200) {
      Map<String, dynamic> decode = jsonDecode(response.body);
      var get = FollowQuranModel.fromJson(decode);
      return get.data;
    }
  }

  getText({required int pageNo, String? kariId}) async {
    var getPagevar = await getPage(pageNo: pageNo, kariId: kariId!);
    return getPagevar.ayahs;
  }

  getAudio() async {}

  convertToArabicNumber(int number){
   return _arabicNumber.convert(number).toString();
  }
}
