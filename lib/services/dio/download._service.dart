import 'package:dio/dio.dart';
import 'package:kuran/services/dio/pdfdownloadlinks_constains.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  bool downloading=true;
  String progressString="";

  Future<void> downloadFile() async{
    Dio dio=Dio();

    try{
      var dir= await getApplicationDocumentsDirectory();
      await dio.download(PdfDownloadLinks.mushafStyle1, "${dir.path}/kuranuthmani.pdf",onReceiveProgress:(rec,total){
        print("Rec:$rec,Total: $total");

        
      } );
    }catch(e){
      print(e);
    }
  }
  
}