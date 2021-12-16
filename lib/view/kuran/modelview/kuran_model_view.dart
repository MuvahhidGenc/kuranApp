import 'dart:convert';
import 'dart:io';

import 'package:kuran/constains/hivedb_constains.dart';
import 'package:kuran/constains/urls_constains.dart';
import 'package:kuran/extantions/hivedb.dart';
import 'package:kuran/services/dio/request.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';
import 'package:kuran/view/kuran/modelview/hiveboxes.dart';
import 'package:path_provider/path_provider.dart';

class KuranModelView {
  late bool dbControl;
  String fileName="surelist.json";
   var getrespone;
    var result;
  Future sureModelListMetod() async {
    
   var dir=await getTemporaryDirectory();

    File file=await File(dir.path+"/"+fileName);

    if(file.existsSync()){
      dynamic data=await file.readAsStringSync();
      data=jsonDecode(data);
      // getrespone=json.decode(data);
        result =await SureNameModel.fromJson(data);
       return result;
    }else{
       getrespone =
        await GetPageAPI().getHttp(UrlsConstaine.ACIK_KURAN_URL + "/surahs");
       // var res=json.decode(getrespone);
        //  String veri=res[0] as String;
         result = await SureNameModel.fromJson(getrespone);
        file.writeAsStringSync(jsonEncode(getrespone),flush: true,mode: FileMode.write);
        return result;
   }
    //print(res[0]["name"]);
   
   // await HiveDb().putBox(HiveDbConstains.SURAHS, getrespone);
  }

  Future dbKeyControl(String key)async{
    dynamic dbControl=HiveDb().getBox(key);
   return dbControl!=null?dbControl:null;
   return true;
  }

}
