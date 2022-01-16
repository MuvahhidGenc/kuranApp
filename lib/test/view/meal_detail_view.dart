import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:hive/hive.dart';
import 'package:kuran/globals/constant/hivedb_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/globals/extantions/hivedb.dart';
import 'package:kuran/test/model/hive_favorilerim_model.dart';
import 'package:kuran/test/model/meal_model.dart';
import 'package:kuran/test/snippet/hive_boxes.dart';
import 'package:kuran/test/viewmodel/surah_versebyverse_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share/share.dart';

class MealDetailView extends StatefulWidget {
  int id;
  String surahName;
  MealDetailView({required this.id, required this.surahName, Key? key})
      : super(key: key);

  @override
  _MealDetailViewState createState() => _MealDetailViewState();
}

class _MealDetailViewState extends State<MealDetailView> {
  var itemPositionListener = ItemPositionsListener.create();
  var itemController = ItemScrollController();
  SurahVerseByVerseViewModel _surahVerseByVerseViewModel =
      SurahVerseByVerseViewModel();
  List<Verse> ayahs = List.empty();
  Box<HiveFavorilerimModel>? box;

  @override
  void initState() {
    // TODO: implement initState

    initAsyc();
    super.initState();
  }

  Future<List<Verse>> initAsyc() async {
    return ayahs =
        await _surahVerseByVerseViewModel.getMealDetail(surahId: widget.id);
  }

  scrolTest(int index) {
    itemController.scrollTo(
        index: 15,
        duration: Duration(seconds: 2),
        curve: Curves.easeInOutCubic);
  }

  addFovoriAyetim(
      {required String arabicText,
      required String latinText,
      required String turkishText,
      required int surahNo,
      required int ayahNo}) {
    HiveFavorilerimModel data = HiveFavorilerimModel(
      arabicText: arabicText,
      latinText: latinText,
      turkishText: turkishText,
      surahNo: surahNo,
      ayahNo: ayahNo,
    );
    box = HiveBoxes.faroviAyetlerimBox();
    box!.add(data);
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
                  itemScrollController: itemController,
                  itemPositionsListener: itemPositionListener,
                  itemBuilder: (context, i) {
                    return Card(
                      // ignore: prefer_const_literals_to_create_immutables
                      child: ListTile(
                        // tileColor: theme.scaffoldBackgroundColor,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            arabicTextWidget(theme, i),
                            dividerWidget(),
                            latinceTextWidget(theme, i),
                            dividerWidget(),
                            translationTextWidget(theme, i),
                            dividerWidget(),
                            bottomButonWidgets(theme, i),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return CircularProgressIndicator();
            }
          }),
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
          iconButonWidget(Icons.play_circle, () {
            print("play");
          }),
          iconButonWidget(Icons.share_rounded, () {
            Share.share(
                "${ayahs[index].verse} \n \n ${ayahs[index].translation!.text}");
          }),
          iconButonWidget(Icons.bookmark_add, () async {
            await HiveDb().putBox(HiveDbConstant.KALDIGIMYER, index);
            await HiveDb().putBox(HiveDbConstant.KALDIGIMYERSURAHID, widget.id);
            SnippetExtanstion(context)
                .showToast("Kaldığınız Yer Kayıt Edildi.");
          }),
          iconButonWidget(Icons.star_outline /* star */, () {
            addFovoriAyetim(
                arabicText: ayahs[index].verse.toString(),
                latinText: ayahs[index].transcription.toString(),
                turkishText: ayahs[index].translation!.text.toString(),
                surahNo: widget.id,
                ayahNo: index + 1);
            print("Favori Ayetim Eklendi");
          }),
        ],
      ),
    );
  }

  IconButton iconButonWidget(IconData icon, VoidCallback voidCallback) {
    return IconButton(
      onPressed: voidCallback,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  Container translationTextWidget(ThemeData theme, int i) {
    return Container(
      color: theme.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(ayahs[i].translation!.text ?? ""),
      ),
    );
  }

  Container arabicTextWidget(ThemeData theme, int i) {
    return Container(
      color: theme.focusColor,
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          ayahs[i].verse ?? "",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  Container latinceTextWidget(ThemeData theme, int i) {
    return Container(
      color: theme.focusColor,
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(ayahs[i].transcription ?? ""),
      )),
    );
  }
}
