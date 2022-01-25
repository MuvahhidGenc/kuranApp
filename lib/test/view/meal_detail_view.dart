import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kuran/globals/constant/hivedb_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/globals/extantions/hivedb.dart';
import 'package:kuran/globals/widgets/ayahcontainerintext_widget.dart';
import 'package:kuran/globals/widgets/iconbuton_widget.dart';
import 'package:kuran/test/model/meal_model.dart';
import 'package:kuran/test/snippet/hive_boxes.dart';
import 'package:kuran/test/viewmodel/favoriayetlerim_viewmodel.dart';
import 'package:kuran/test/viewmodel/surah_versebyverse_viewmodel.dart';
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
  bool latinTextVisible=true;
   bool arabicTextVisible=true;
  var _favoriAyetlerimViewModel = FavoriAyetlerimViewModel();
  

  @override
  void initState() {
    // TODO: implement initState

    ayahsList();
    initAsyc();
    widget.gotoAyah != null
        ? _favoriAyetlerimViewModel.waitScrolWork(widget.gotoAyah!)
        : null;
        
    //itemController.jumpTo(index: newGotoAyah!);
    super.initState();
  }

  initAsyc()async{
     latinTextVisible=await HiveDb().getBox(HiveDbConstant.TEXTLATINVISIBLE)??true;
     arabicTextVisible=await HiveDb().getBox(HiveDbConstant.TEXTARABICVISIBLE)??true;
  }

  ayahsList() async {
    ayahs = await _surahVerseByVerseViewModel.getMealDetail(surahId: widget.id);
   
    return ayahs;
  }

  @override
  Widget build(BuildContext context) {
    var theme = SnippetExtanstion(context).theme;
    return Scaffold(
       
      appBar: AppBar(
        title: Text(widget.surahName + " Süresi"),
         leading: IconButton(
      icon: Icon(Icons.arrow_back,
      ),
      onPressed: () => Navigator.of(context).pop(),
    ),
      ),
      endDrawer: Drawer(
         elevation: 0.0,
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(top:5.0),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:5.0),
                  child: ListTile(
                    title:   SwitchListTile(
                          value: arabicTextVisible,
                          title: const Text("Arapça Metin"),
                          secondary: Icon(Icons.book_online_outlined),
                          onChanged: (bool? val) async{
                            arabicTextVisible=!arabicTextVisible;
                            await HiveDb().putBox(HiveDbConstant.TEXTARABICVISIBLE,arabicTextVisible);
                            print("${HiveDb().getBox(HiveDbConstant.TEXTARABICVISIBLE)} - $arabicTextVisible - "+latinTextVisible.toString());
                            setState(() {
                             
                            });
                          }),
                  ),
                ),
                 Padding(
                   padding: const EdgeInsets.only(top:8.0),
                   child: ListTile(
                    title:   SwitchListTile(
                          value: latinTextVisible,
                          title: const Text("Türkçe Okunuş Metin"),
                          secondary: Icon(Icons.book_online_outlined),
                          onChanged: (bool? val) {
                            latinTextVisible=val!;
                            HiveDb().putBox(HiveDbConstant.TEXTLATINVISIBLE,val);
                            setState(() {
                             
                            });
                          }),
                ),
                 ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: ayahsList(),
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
                       arabicTextVisible? AyahCardInTextWidget(
                          color: theme.focusColor,
                          ayah: ayahs[i].verse!,
                          textPosition: Alignment.centerRight,
                          style: TextStyle(fontSize: 25),
                        ):SizedBox(),

                        latinTextVisible? dividerWidget():SizedBox(),
                     latinTextVisible? AyahCardInTextWidget(
                          color: theme.focusColor,
                          ayah: ayahs[i].transcription!,
                          textPosition: Alignment.centerLeft,
                        ):SizedBox(),
                       
                        dividerWidget(),
                        AyahCardInTextWidget(
                          color: theme.focusColor,
                          ayah: "${i + 1} - " + ayahs[i].translation!.text!,
                          textPosition: Alignment.centerLeft,
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
              voidCallback: () async {
                var ayahUrl = await _surahVerseByVerseViewModel.getAyahAudio(
                    surahNo: widget.id, ayahNo: index + 1);
                if (ayahUrl != "hata") {
                  _surahVerseByVerseViewModel.playUrlSingleAyah(url: ayahUrl);
                }

                print(index);
              }),
          IconButonWidget(
              icon: Icons.share_rounded,
              voidCallback: () {
                Share.share(
                    "${ayahs[index].verse} \n \n ${ayahs[index].translation!.text}");
              }),
         IconButonWidget(
              icon: _surahVerseByVerseViewModel.isFavoriControl(
                      ayahNo: index + 1, surahNo: widget.id,box: HiveBoxes.kaldigimyerBox())
                  ? Icons.bookmark
                  : Icons.bookmark_add_outlined /* star */,
              voidCallback: () async {
                bool isFavori = await _surahVerseByVerseViewModel.isFavori(
                    surahNo: widget.id, ayahNo: index + 1,box: HiveBoxes.kaldigimyerBox());
                if (!isFavori) {
                  _favoriAyetlerimViewModel.addFovoriAyetim(
                      arabicText: ayahs[index].verse.toString(),
                      latinText: ayahs[index].transcription.toString(),
                      turkishText: ayahs[index].translation!.text.toString(),
                      surahNo: widget.id,
                      ayahNo: index + 1,
                      surahName: widget.surahName,box: HiveBoxes.kaldigimyerBox());

                  SnippetExtanstion(context).showToast(
                      "Kaldığın Yer Kayıt Edildi.",
                      duration: 3);
                } else {
                  SnippetExtanstion(context)
                      .showToast("Kaldığın Yer Kaldırıldı", duration: 3);
                }

                setState(() {});
              }),
          IconButonWidget(
              icon: _surahVerseByVerseViewModel.isFavoriControl(
                      ayahNo: index + 1, surahNo: widget.id,box: HiveBoxes.faroviAyetlerimBox())
                  ? Icons.star
                  : Icons.star_outline /* star */,
              voidCallback: () async {
                bool isFavori = await _surahVerseByVerseViewModel.isFavori(
                    surahNo: widget.id, ayahNo: index + 1,box: HiveBoxes.faroviAyetlerimBox());
                if (!isFavori) {
                  _favoriAyetlerimViewModel.addFovoriAyetim(
                      arabicText: ayahs[index].verse.toString(),
                      latinText: ayahs[index].transcription.toString(),
                      turkishText: ayahs[index].translation!.text.toString(),
                      surahNo: widget.id,
                      ayahNo: index + 1,
                      surahName: widget.surahName,box: HiveBoxes.faroviAyetlerimBox());

                  SnippetExtanstion(context).showToast(
                      "Ayet Favorileri Ayetlerime Kayıt Edildi.",
                      duration: 3);
                } else {
                  SnippetExtanstion(context)
                      .showToast("Fovorim Kaldırıldı", duration: 3);
                }

                setState(() {});
              }),
        ],
      ),
    );
  }
}
