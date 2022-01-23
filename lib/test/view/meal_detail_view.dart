import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:hive/hive.dart';
import 'package:kuran/globals/constant/hivedb_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/globals/extantions/hivedb.dart';
import 'package:kuran/globals/widgets/ayahcontainerintext_widget.dart';
import 'package:kuran/globals/widgets/iconbuton_widget.dart';
import 'package:kuran/test/model/hive_favorilerim_model.dart';
import 'package:kuran/test/model/meal_model.dart';
import 'package:kuran/test/snippet/hive_boxes.dart';
import 'package:kuran/test/viewmodel/favoriayetlerim_viewmodel.dart';
import 'package:kuran/test/viewmodel/surah_versebyverse_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share/share.dart';

class MealDetailView extends StatefulWidget {
  int id; // Surah id
  String surahName;
  int? gotoAyah;
  MealDetailView(
      {required this.id, required this.surahName, this.gotoAyah, Key? key})
      : super(key: key);

  @override
  _MealDetailViewState createState() => _MealDetailViewState();
}

class _MealDetailViewState extends State<MealDetailView> {
  SurahVerseByVerseViewModel _surahVerseByVerseViewModel =
      SurahVerseByVerseViewModel();
  List<Verse> ayahs = List.empty();

  var _favoriAyetlerimViewModel = FavoriAyetlerimViewModel();

  @override
  void initState() {
    // TODO: implement initState

    initAsyc();
    _favoriAyetlerimViewModel.waitScrolWork(widget.gotoAyah!);
    //itemController.jumpTo(index: newGotoAyah!);
    super.initState();
  }

  initAsyc() async {
    ayahs = await _surahVerseByVerseViewModel.getMealDetail(surahId: widget.id);
    return ayahs;
  }

  @override
  Widget build(BuildContext context) {
    var theme = SnippetExtanstion(context).theme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName + " Süresi"),
      ),
      body: FutureBuilder(
        future: initAsyc(),
        builder: (context, a) {
          if (a.hasData) {
            return ScrollablePositionedList.builder(
              itemCount: ayahs.length,
              itemScrollController: _favoriAyetlerimViewModel.itemController,
              itemPositionsListener:
                  _favoriAyetlerimViewModel.itemPositionListener,
              itemBuilder: (context, i) {
                return Card(
                  // ignore: prefer_const_literals_to_create_immutables
                  child: ListTile(
                    // tileColor: theme.scaffoldBackgroundColor,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // arabicTextWidget(theme, i),
                        AyahCardInTextWidget(
                          color: theme.focusColor,
                          ayah: ayahs[i].verse!,
                          textPosition: Alignment.topRight,
                          style: TextStyle(fontSize: 20),
                        ),
                        dividerWidget(),
                        AyahCardInTextWidget(
                          color: theme.focusColor,
                          ayah: ayahs[i].transcription!,
                          textPosition: Alignment.topRight,
                        ),
                        dividerWidget(),
                        AyahCardInTextWidget(
                          color: theme.focusColor,
                          ayah: "${i + 1} - " + ayahs[i].translation!.text!,
                          textPosition: Alignment.topRight,
                        ),
                        dividerWidget(),
                        bottomButonWidgets(theme, i, context),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Divider dividerWidget() {
    return Divider(
      height: 1,
    );
  }

  Container bottomButonWidgets(
      ThemeData theme, int index, BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      //color: theme.backgroundColor,
      child: Wrap(
        spacing: 12,
        children: [
          IconButonWidget(
              icon: Icons.play_circle,
              voidCallback: () {
                print("play");
              }),
          IconButonWidget(
              icon: Icons.share_rounded,
              voidCallback: () {
                Share.share(
                    "${ayahs[index].verse} \n \n ${ayahs[index].translation!.text}");
              }),
          IconButonWidget(
              icon: Icons.bookmark_add,
              voidCallback: () async {
                await HiveDb().putBox(HiveDbConstant.KALDIGIMYER, index);
                await HiveDb()
                    .putBox(HiveDbConstant.KALDIGIMYERSURAHID, widget.id);
                SnippetExtanstion(context)
                    .showToast("Kaldığınız Yer Kayıt Edildi.");
              }),
          IconButonWidget(
              icon: Icons.star_outline /* star */,
              voidCallback: () {
                _favoriAyetlerimViewModel.addFovoriAyetim(
                    arabicText: ayahs[index].verse.toString(),
                    latinText: ayahs[index].transcription.toString(),
                    turkishText: ayahs[index].translation!.text.toString(),
                    surahNo: widget.id,
                    ayahNo: index + 1,
                    surahName: widget.surahName);

                SnippetExtanstion(context).showToast(
                    "Ayet Favorileri Ayetlerime Kayıt Edildi.",
                    duration: 3);
              }),
        ],
      ),
    );
  }
}
