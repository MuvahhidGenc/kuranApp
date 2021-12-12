import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:hive/hive.dart';
import 'package:kuran/test/snippet/hive_boxes.dart';
import 'package:kuran/view/kuran/consts/constaine.dart';
import 'package:kuran/view/kuran/model/kuran_model.dart';
import 'package:kuran/view/widgets/listtile_widget.dart';

class Kuran extends StatefulWidget {
  const Kuran({Key? key}) : super(key: key);

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
  List<KuranModel> list = [];
  final kuranModel = KuranModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kuranPageInit();
  }

  Future kuranPageInit() async {
    box = await Hive.openBox("kuranPage");
    list = await kuranModel.juzListCount();
    /* list = list.map((e) {
      return KuranModel(juz: e.juz, page: e.page);
    }).toList();*/
    setState(() {
      pageNum = box!.get("kuranPage");
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
        appBar: AppBar(
          //title: Text("Kuran Oku",style: TextStyle(color: Colors.black),),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: cachedPdfReader.cachedFromUrl(Constaine.url),
        floatingActionButton: Text("$pageNum / $pageTotalNum"),
        endDrawer: Drawer(
          elevation: 0.0,
          child: Container(
            color: Colors.transparent,
            child: ListView(
              children: [
                const Padding(
                    padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                )),
                ExpansionTile(
                  title: const Text("Süreler"),
                  leading: const Icon(Icons.book_online_outlined),
                  children: list.map<ListTile>((e) {
                    return ListTile(
                        title: Text(e.juz.toString() + ".juz"),
                        subtitle: Text("Sayfa : " + e.page.toString()),
                        onTap: () async {
                          var deneme = await box!.put("kuranPage", e.page);

                          setState(() {
                            pageNum = e.page;
                          });
                          cachedPdfReader.cachedFromUrl(Constaine.url);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      super.widget));
                        });
                  }).toList(),
                ),
              ],
            ),
          ),
        ));
  }

  PDF get cachedPdfReader => PDF(
        swipeHorizontal: false,
        nightMode: false,
        autoSpacing: true,
        pageFling: true,
        defaultPage: pageNum == null ? 1 : pageNum!,
        onPageChanged: (int? current, int? total) {
          _pageCountController.add('${current! + 1} - $total');
          setState(() {
            pageNum = current;
            pageTotalNum = total;

            box!.put("kuranPage", current);

            print(pageNum.toString() + " " + box!.get("kuranPage").toString());
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
