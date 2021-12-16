import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:hive/hive.dart';
import 'package:kuran/constains/hivedb_constains.dart';
import 'package:kuran/constains/urls_constains.dart';
import 'package:kuran/extantions/hivedb.dart';
import 'package:kuran/services/dio/request.dart';
import 'package:kuran/test/snippet/hive_boxes.dart';
import 'package:kuran/view/kuran/consts/constaine.dart';
import 'package:kuran/view/kuran/model/kuran_model.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';
import 'package:kuran/view/kuran/modelview/hiveboxes.dart';
import 'package:kuran/view/kuran/modelview/kuran_model_view.dart';
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
  SureNameModel? sureModelList;
  final kuranModel = KuranModel();
  bool nightMode = false;

  //var response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kuranPageInit();
  }

  Future kuranPageInit() async {
    var result = await KuranModelView()
        .sureModelListMetod(); // get Süre Name And Details
    list = await kuranModel.juzListCount(); //  get Juz List Count
    var getpageNum =
        await KuranModelView().dbKeyControl(HiveDbConstains.kuranPageName) ??
            0; // db Control method
    nightMode =
        await KuranModelView().dbKeyControl(HiveDbConstains.NIGHTMODE) ?? false;
    setState(() {
      nightMode;
      sureModelList = result; //Updete Widgets
      pageNum = getpageNum;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Hive.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBarWidget(context),
        body: pageNum != null
            ? cachedPdfReader.cachedFromUrl(Constaine.url)
            : Center(
                child: Text("Yükleniyor"),
              ),
        floatingActionButton: Text("$pageNum / $pageTotalNum"),
        endDrawer: drawerList(context));
  }

  AppBar appBarWidget(BuildContext context) {
    return AppBar(
      //title: Text("Kuran Oku",style: TextStyle(color: Colors.black),),
      iconTheme: IconThemeData(color: !nightMode ? Colors.black : Colors.white),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back,
            color: !nightMode ? Colors.black : Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Drawer drawerList(BuildContext context) {
    return Drawer(
      elevation: 0.0,
      child: Container(
        color: Colors.transparent,
        child: ListView(
          children: [
            const Padding(
                padding: EdgeInsets.symmetric(
              vertical: 10.0,
            )),
            SwitchListTile(
                value: nightMode,
                title: Text("Gece Modu "),
                secondary: Icon(Icons.nightlight),
                onChanged: (bool? val) {
                  setState(() {
                    nightMode = val!;
                    HiveDb().putBox(HiveDbConstains.NIGHTMODE, nightMode);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => super.widget));
                  });
                }),
            expansionTileJuzler(context),
            expansionTileSureler(context),
          ],
        ),
      ),
    );
  }

  ExpansionTile expansionTileSureler(BuildContext context) {
    return ExpansionTile(
      title: const Text("Sureler"),
      leading: Icon(Icons.bookmark),
      children: sureModelList != null
          ? sureModelList!.data!.map<ListTile>((e) {
              return ListTile(
                title: Text(e.name!),
                subtitle: Text("Sayfa : " + e.pageNumber!.toString()),
                // leading: Text(data),
                trailing: Text("Ayet Sayısı : " + e.verseCount!.toString()),
                onTap: () async {
                  if (e.pageNumber == 0 || e.pageNumber == 1) {
                    pageNum = e.pageNumber! + 1;
                  } else {
                    pageNum = e.pageNumber;
                  }
                  // pageNum = e.pageNumber;
                  await HiveDb().putBox(HiveDbConstains.kuranPageName, pageNum);
                  // await box!.put(HiveDbConstains.kuranPageName, pageNum);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget));
                },
              );
            }).toList()
          : [Text("Yükleniyor")],
    );
  }

  ExpansionTile expansionTileJuzler(BuildContext context) {
    return ExpansionTile(
      title: const Text("Cüzler"),
      leading: const Icon(Icons.book_online_outlined),
      children: list.map<ListTile>((e) {
        return ListTile(
            title: Text(e.juz.toString() + ". Cüz"),
            subtitle: Text("Sayfa : " + e.page.toString()),
            onTap: () async {
              await HiveDb().putBox(HiveDbConstains.kuranPageName, e.page);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => super.widget));
            });
      }).toList(),
    );
  }

  PDF get cachedPdfReader => PDF(
        swipeHorizontal: false,
        nightMode: nightMode,
        autoSpacing: true,
        pageFling: true,
        defaultPage: pageNum == null ? 1 : pageNum!,
        onPageChanged: (int? current, int? total) {
          _pageCountController.add('${current! + 1} - $total');

          setState(() {
            pageNum = current;
            pageTotalNum = total;
          });
          HiveDb().putBox(HiveDbConstains.kuranPageName, current);
          print(box!.get("kuranPage"));
        },
        onViewCreated: (PDFViewController pdfViewController) async {
          _pdfViewController.complete(pdfViewController);
          final int? currentPage = await pdfViewController.getCurrentPage();
          final int? pageCount = await pdfViewController.getPageCount();
          _pageCountController.add('${currentPage! + 1} - $pageCount');
        },
      );
}
