import '../view/kuran_view.dart';

class KuranModel {
  int? juz;
  int? page;
  KuranModel({this.juz, this.page});
  Map<String, int> sureNameList = {
    "Fatiha": 1,
    "Fatiha": 1,
    "Fatiha": 1,
  };

  Map<int, int> juzList = {
    /* "1.Juz":1,
    "2.Juz":22,
    "3.Juz":43,
    "4.Juz":63,
    "5.Juz":83,
    "6.Juz":103,
    "7.Juz":1,
    "8.Juz":1,
    "9.Juz":1,
    "10.Juz":1,
    "11.Juz":1,
    "1.Juz":1,
    "1.Juz":1,
    "1.Juz":1,
    "1.Juz":1,
    "1.Juz":1,
    "1.Juz":1,
    "1.Juz":1,
    "1.Juz":1,
    "1.Juz":1,
    "1.Juz":1,
    "1.Juz":1,
    "1.Juz":1,
    "1.Juz":1,
    "1.Juz":1,
    "1.Juz":1,
    "1.Juz":1,
    "1.Juz":1,
    "1.Juz":1,
    "1.Juz":1,*/
  };

  /* Future<Map<int, int>> juzListCount(Map<int, int> map) {
    for (int i = 1; i <= 30; i++) {
      map.addAll({i: i});
    }
    return map;
  }*/

  Future<List<KuranModel>> juzListCount() async {
    List<KuranModel> list = [];
    int sayfaInt = 1;
    for (int i = 1; i <= 30; i++) {
      if (i == 1) sayfaInt = 0;
      if (i != 1 && i != 2) sayfaInt += 20;
      if (i == 2) sayfaInt += 21;

      list.add(KuranModel(juz: i, page: sayfaInt));
    }
    return await list;
  }
}
