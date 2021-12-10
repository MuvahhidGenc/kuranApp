import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:hive/hive.dart';
import 'package:kuran/test/snippet/hive_boxes.dart';
import 'package:kuran/view/kuran/consts/constaine.dart';

class Kuran extends StatefulWidget {
  const Kuran({ Key? key }) : super(key: key);

  @override
  _KuranState createState() => _KuranState();
}

class _KuranState extends State<Kuran> {


  final Completer<PDFViewController> _pdfViewController =
      Completer<PDFViewController>();

  final StreamController<String> _pageCountController =
      StreamController<String>();
  Box<dynamic>? box;
  int? pageNum;
  int? pageTotalNum;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    kuranPageInit();
    

  }

  Future kuranPageInit()async{
     box=await Hive.openBox("kuranPage");
    setState(() {
        pageNum=box!.get("kuranPage");
    });
     
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:AppBar(
        //title: Text("Kuran Oku",style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(color: Colors.black54),
        backgroundColor: Colors.transparent,
      elevation: 0.0,
      ),
      body: cachedPdfReader.cachedFromUrl(Constaine.url),
      floatingActionButton: Text("$pageNum / $pageTotalNum"),
    );
  }

  PDF get cachedPdfReader=>PDF(
      swipeHorizontal: false,
        nightMode: false,
        autoSpacing: true,
        pageFling: true,
        defaultPage:pageNum==null ?1:pageNum!,
        onPageChanged: (int? current, int? total) {
          _pageCountController.add('${current! + 1} - $total');
          setState((){
            pageNum=current;
            pageTotalNum=total;
           
            box!.put("kuranPage", current);

            print(pageNum.toString()+" "+box!.get("kuranPage").toString());
          });
        },
            
        onViewCreated: (PDFViewController pdfViewController) async {
          _pdfViewController.complete(pdfViewController);
          final int? currentPage = await pdfViewController.getCurrentPage();
          final int? pageCount = await pdfViewController.getPageCount();
          _pageCountController.add('${currentPage! + 1} - $pageCount');
        },
    );
  
}