import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kuran/services/dio/download._service.dart';
import 'package:kuran/services/dio/pdfdownloadlinks_constains.dart';
import 'package:path_provider/path_provider.dart';

class KuranDownloadView extends StatefulWidget {
  const KuranDownloadView({ Key? key }) : super(key: key);

  @override
  _KuranDownloadViewState createState() => _KuranDownloadViewState();
}

class _KuranDownloadViewState extends State<KuranDownloadView> {

 @override
  void initState(){
    super.initState();

    downloadFile();
  }


  Future<void> downloadFile() async{
    Dio dio=Dio();

    try{
      var dir= await getApplicationDocumentsDirectory();
      await dio.download(PdfDownloadLinks.mushafStyle1, "${dir.path}/kuranuthmani.pdf",onReceiveProgress:(rec,total){
        print("Rec:$rec,Total: $total");

        setState(() {
          DownloadService().downloading=true;
          DownloadService().progressString=((rec/total)*100).toStringAsFixed(0)+"%";
        });

        
      } );
    }catch(e){
      print(e);
    }

    setState(() {
      DownloadService().downloading=false;
      DownloadService().progressString="İndirme İşlemi Tamamlamdı";
    });

    print("Dosya İndirildi");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Kuran İndirme Ekranı"),
      ),
      body:DownloadService().downloading ? Center(
        child: Container(
            height: 120.0,
            width: 200.0,
            child: Card(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text("İndiriliyor"),
                ],
              ),
            ),
          ),
      ): Text("Kuran İndirme Ekranı Test"),
    );
  }
}