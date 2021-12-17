import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:hive/hive.dart';
import 'package:kuran/globals/constant/hivedb_constant.dart';
import 'package:kuran/globals/extantions/hivedb.dart';
import '../../../globals/constant/urls_constant.dart';
import '../model/kuran_model.dart';
import '../model/sure_name_model.dart';
import '../modelview/kuran_model_view.dart';

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
        await KuranModelView().dbKeyControl(HiveDbConstant.kuranPageName) ??
            0; // db Control method
    nightMode =
        await KuranModelView().dbKeyControl(HiveDbConstant.NIGHTMODE) ?? false;
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
            ? cachedPdfReader.cachedFromUrl(UrlsConstant.PDF_KURAN_URL)
            :const Center(
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
                title:const Text("Gece Modu "),
                secondary: Icon(Icons.nightlight),
                onChanged: (bool? val) {
                  setState(() {
                    nightMode = val!;
                    HiveDb().putBox(HiveDbConstant.NIGHTMODE, nightMode);
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
                  await HiveDb().putBox(HiveDbConstant.kuranPageName, pageNum);
                  // await box!.put(HiveDbConstant.kuranPageName, pageNum);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget));
                },
              );
            }).toList()
          : [const Text("Yükleniyor")],
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
              await HiveDb().putBox(HiveDbConstant.kuranPageName, e.page);
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
          HiveDb().putBox(HiveDbConstant.kuranPageName, current);
        },
        onViewCreated: (PDFViewController pdfViewController) async {
          _pdfViewController.complete(pdfViewController);
          final int? currentPage = await pdfViewController.getCurrentPage();
          final int? pageCount = await pdfViewController.getPageCount();
          _pageCountController.add('${currentPage! + 1} - $pageCount');
        },
      );
}
