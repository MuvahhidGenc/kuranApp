import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/globals/widgets/ayahcontainerintext_widget.dart';
import 'package:kuran/globals/widgets/iconbuton_widget.dart';
import 'package:kuran/test/snippet/hive_boxes.dart';
import 'package:kuran/view/favorikaldigimyer/model/hive_favorilerim_model.dart';
import 'package:kuran/view/meal/view/meal_detail_view.dart';
import 'package:share/share.dart';

class FavoriAyetlerimView extends StatefulWidget {
  String nerden;
  FavoriAyetlerimView({required this.nerden, Key? key}) : super(key: key);

  @override
  State<FavoriAyetlerimView> createState() => _FavoriAyetlerimViewState();
}

class _FavoriAyetlerimViewState extends State<FavoriAyetlerimView> {
  String? title;
  Box<HiveFavorilerimModel>? _box;
  //var _box;

  @override
  void initState() {
    // TODO: implement initState
    initAsyc();
    super.initState();
  }

  initAsyc() async {
    if (widget.nerden == "favori") {
      _box = HiveBoxes.faroviAyetlerimBox();
      title = "Favori Ayetlerim";
    } else {
      _box = HiveBoxes.kaldigimyerBox();
      title = "Kaldığım Yerler";
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = SnippetExtanstion(context).theme;
    return Scaffold(
      /* appBar: AppBar(
        title: Text(title ?? ""),
      ),*/
      body: _box != null
          ? ValueListenableBuilder<Box<HiveFavorilerimModel>>(
              valueListenable: _box!.listenable(),
              builder: (context, box, widget) {
                if (box.length == 0) {
                  return Center(
                    child: Text("İşaretlenmiş Ayet Bulunmadı."),
                  );
                }
                return ListView.builder(
                  dragStartBehavior: DragStartBehavior.start,
                  itemCount: box.length,
                  reverse: true,
                  itemBuilder: (context, i) {
                    return Card(
                      child: ListTile(
                        title: Column(
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: IconButonWidget(
                                  icon: Icons.close,
                                  voidCallback: () {
                                    setState(() {
                                      box.delete(box.keys.elementAt(i));
                                    });
                                    SnippetExtanstion(context).showToast(
                                        "Silme İşlemi Başarılı",
                                        duration: 2);
                                  }),
                            ),
                            AyahCardInTextWidget(
                              color: theme.focusColor,
                              ayah: _box!.values.elementAt(i).arabicText!,
                              textPosition: Alignment.topRight,
                              style: TextStyle(fontSize: 22),
                            ),
                            dividerWidget(),
                            AyahCardInTextWidget(
                              color: theme.focusColor,
                              ayah: _box!.values.elementAt(i).latinText!,
                              textPosition: Alignment.topLeft,
                            ),
                            dividerWidget(),
                            AyahCardInTextWidget(
                              color: theme.focusColor,
                              ayah: "${_box!.values.elementAt(i).ayahNo} - " +
                                  _box!.values.elementAt(i).turkishText!,
                              textPosition: Alignment.topLeft,
                            ),
                            dividerWidget(),
                            AyahCardInTextWidget(
                              color: Colors.transparent,
                              ayah: _box!.values
                                      .elementAt(i)
                                      .surahName
                                      .toString() +
                                  " / ${_box!.values.elementAt(i).ayahNo} ",
                              textPosition: Alignment.center,
                            ),
                            bottomButonWidgets(theme, i),
                          ],
                        ),
                      ),
                    );
                  },
                );
              })
          : CircularProgressIndicator(),
    );
  }

  Divider dividerWidget() {
    return Divider(
      height: 1,
    );
  }

  Container bottomButonWidgets(ThemeData theme, int index) {
    return Container(
      alignment: Alignment.bottomRight,
      //color: theme.backgroundColor,
      child: Wrap(
        spacing: 12,
        children: [
          IconButonWidget(
              icon: Icons.share_rounded,
              voidCallback: () {
                Share.share(
                    "${_box!.values.elementAt(index).arabicText} \n \n ${_box!.values.elementAt(index).turkishText} \n \n ${_box!.values.elementAt(index).surahName}");
              }),
          IconButonWidget(
              icon: Icons.arrow_right_alt /* star */,
              voidCallback: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MealDetailView(
                          id: _box!.values.elementAt(index).surahNo!.toInt(),
                          surahName: _box!.values
                              .elementAt(index)
                              .surahName
                              .toString(),
                          gotoAyah:
                              _box!.values.elementAt(index).ayahNo!.toInt(),
                        )));
              }),
        ],
      ),
    );
  }
}
