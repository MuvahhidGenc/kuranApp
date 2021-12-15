import 'package:kuran/constains/hivedb_constains.dart';
import 'package:kuran/constains/urls_constains.dart';
import 'package:kuran/extantions/hivedb.dart';
import 'package:kuran/services/dio/request.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';
import 'package:kuran/view/kuran/modelview/hiveboxes.dart';

class KuranModelView {
  Future sureModelListMetod() async {
    var getrespone =
        await GetPageAPI().getHttp(UrlsConstaine.ACIK_KURAN_URL + "/surahs");

    //print(res[0]["name"]);
    var result = await SureNameModel.fromJson(getrespone);
    return result;
  }

  Future<int> dbController() async {
    int? pageNum;
    var box = await KuranPageHiveBoxes.getOpenKuranPageBox;
    pageNum = await HiveDb().getBox(HiveDbConstains.kuranPageName); // get Db kuranPage
    if (pageNum == null) {
      HiveDb().putBox(HiveDbConstains.kuranPageName, pageNum);

      return 1;
    }
    print(pageNum.toString() + " Bu");
    return pageNum;
  }
}
