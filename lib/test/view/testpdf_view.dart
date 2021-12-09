import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:kuran/services/dio/pdfdownloadlinks_constains.dart';
import 'package:path_provider/path_provider.dart';

class TestPdfView extends StatefulWidget {
  const TestPdfView({ Key? key }) : super(key: key);

  @override
  _TestPdfViewState createState() => _TestPdfViewState();
}

class _TestPdfViewState extends State<TestPdfView> {

String? path;
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getPath();
  }

  void getPath()async{
    var dir=await getApplicationDocumentsDirectory();
    path="${dir.path}/kuranuthmani.pdf";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arapça Kur'an"),
      ),
      body:const PDF().cachedFromUrl(PdfDownloadLinks.mushafStyle1),
      
    );
  }
}

