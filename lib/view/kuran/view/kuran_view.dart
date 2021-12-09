import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
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

  int? pageNum;
  int? pageTotalNum;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cachedPdfReader.cachedFromUrl(Constaine.url),
      floatingActionButton: Text("$pageNum / $pageTotalNum"),
    );
  }

  PDF get cachedPdfReader=>PDF(
      swipeHorizontal: true,
        nightMode: false,
        autoSpacing: true,
        pageFling: true,
        defaultPage: 1,
        onPageChanged: (int? current, int? total) {
          _pageCountController.add('${current! + 1} - $total');
          setState(() {
            pageNum=current;
            pageTotalNum=total;
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