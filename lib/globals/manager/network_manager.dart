import 'package:dio/dio.dart';
import '../constant/urls_constant.dart';

import 'package:path_provider/path_provider.dart';

class NetworkManager {
    bool downloading=true;
  String progressString="";

  Future<void> downloadFile() async{
    Dio dio=Dio();
    
    try{
      var dir= await getApplicationDocumentsDirectory();
      await dio.download(UrlsConstant.PDF_KURAN_URL, "${dir.path}/kuranuthmani.pdf",onReceiveProgress:(rec,total){
        print("Rec:$rec,Total: $total test");
          downloading=true;
          progressString=((rec/total)*100).toStringAsFixed(0)+"%";
          print("test2");
        //print(dir.path+"/kuranuthmani.dpf");
      } );
    }catch(e){
      print(e);
    }
      downloading=false;
      progressString="İndirme İşlemi Tamamlamdı";
  
}  
}