import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kuran/globals/constant/hivedb_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/globals/extantions/hivedb.dart';
import 'package:kuran/globals/manager/network_manager.dart';
import 'package:kuran/globals/widgets/alertdialog_widget.dart';
import 'package:kuran/globals/widgets/ayahcontainerintext_widget.dart';
import 'package:kuran/globals/widgets/iconbuton_widget.dart';
import 'package:kuran/test/model/meal_model.dart';
import 'package:kuran/test/model/versebyverse_kari_model.dart';
import 'package:kuran/test/snippet/hive_boxes.dart';
import 'package:kuran/test/viewmodel/favoriayetlerim_viewmodel.dart';
import 'package:kuran/test/viewmodel/surah_versebyverse_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
  bool latinTextVisible = true;
  bool arabicTextVisible = true;
  var _favoriAyetlerimViewModel = FavoriAyetlerimViewModel();
  var _verseByVerseKariModel = VerseByVerseKariModel();
  String? selectKariId;

  @override
  void initState() {
    // TODO: implement initState
    _surahVerseByVerseViewModel.getAudioKariList();

    ayahsList();
    initAsyc();
    widget.gotoAyah != null
        ? _favoriAyetlerimViewModel.waitScrolWork(widget.gotoAyah!)
        : null;

    //itemController.jumpTo(index: newGotoAyah!);
    super.initState();
  }

  initAsyc() async {
    _verseByVerseKariModel =
        await _surahVerseByVerseViewModel.getAudioKariList();
    latinTextVisible =
        await HiveDb().getBox(HiveDbConstant.TEXTLATINVISIBLE) ?? true;
    arabicTextVisible =
        await HiveDb().getBox(HiveDbConstant.TEXTARABICVISIBLE) ?? true;
    await HiveDb().openBox(HiveDbConstant.SELECTVERSEBYVERSEKARI);
    selectKariId =
        await HiveDb().getBox(HiveDbConstant.SELECTVERSEBYVERSEKARI) ??
            "ar.alafasy";
    setState(() {});
  }

  ayahsList() async {
    ayahs = await _surahVerseByVerseViewModel.getMealDetail(surahId: widget.id);

    return ayahs;
  }

  @override
  Widget build(BuildContext context) {
    var theme = SnippetExtanstion(context).theme;
    var provider=Provider.of<SurahVerseByVerseViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName + " Süresi"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      endDrawer: drawerWidget(theme),
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
                        arabicTextVisible
                            ? AyahCardInTextWidget(
                                color: theme.focusColor,
                                ayah: ayahs[i].verse!,
                                textPosition: Alignment.centerRight,
                                style: TextStyle(fontSize: 25),
                              )
                            : SizedBox(),

                        latinTextVisible ? dividerWidget() : SizedBox(),
                        latinTextVisible
                            ? AyahCardInTextWidget(
                                color: theme.focusColor,
                                ayah: ayahs[i].transcription!,
                                textPosition: Alignment.centerLeft,
                              )
                            : SizedBox(),

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
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Drawer drawerWidget(ThemeData theme) {
    return Drawer(
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: ListView(
          children: [
            swichVisibleWidget(
                value: arabicTextVisible,
                dbKey: HiveDbConstant.TEXTARABICVISIBLE,
                title: "Arapça Metin",
                progress: "arapca"),
            swichVisibleWidget(
                value: latinTextVisible,
                dbKey: HiveDbConstant.TEXTLATINVISIBLE,
                title: "Türkçe Okunuş Metin",
                progress: "latince"),
            ExpansionKariListWidget(theme)
          ],
        ),
      ),
    );
  }

  ExpansionTile ExpansionKariListWidget(ThemeData theme) {
    return ExpansionTile(
        title: Text(
          "Seslendiren Kari",
          style: TextStyle(color: theme.listTileTheme.textColor),
        ),
        leading: Icon(
          Icons.mic_external_on,
          color: theme.listTileTheme.textColor,
        ),
        children: [
          _verseByVerseKariModel.data != null
              ? ScrollablePositionedList.builder(
                  itemCount: _verseByVerseKariModel.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return Card(
                      child: ListTile(
                        tileColor: selectKariId ==
                                _verseByVerseKariModel.data![i].identifier
                            ? theme.primaryColor
                            : null,
                        leading: Icon(Icons.mic_external_on),
                        title: Text(
                          _verseByVerseKariModel.data![i].englishName
                              .toString(),
                        ),
                        onTap: () {
                          selectKariId =
                              _verseByVerseKariModel.data![i].identifier;
                          HiveDb().putBox(HiveDbConstant.SELECTVERSEBYVERSEKARI,
                              _verseByVerseKariModel.data![i].identifier);
                          setState(() {});
                        },
                      ),
                    );
                  })
              : CircularProgressIndicator(),
        ]);
  }

  Padding swichVisibleWidget(
      {required bool value,
      required String dbKey,
      required String title,
      required String progress}) {
    return Padding(
      padding: const EdgeInsets.only(top: 1.0),
      child: ListTile(
        title: SwitchListTile(
            value: value,
            title: Text(title),
            secondary: Icon(Icons.book_online_outlined),
            onChanged: (bool? val) async {
              progress == "latince"
                  ? latinTextVisible = !latinTextVisible
                  : arabicTextVisible = !arabicTextVisible;

              await HiveDb().putBox(dbKey, value);
              setState(() {});
            }),
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
          audioPlayButtonWidget(index,context),
          shareButtonWidget(index),
          kaldigimYerButtonWidget(index, context),
          favoriButton(index, context),
        ],
      ),
    );
  }

  Widget audioPlayButtonWidget(int index,BuildContext context) {
   
      return IconButonWidget(
        icon: Icons.play_circle,
        voidCallback: () async {
          if(await NetworkManager().connectionControl()){
             var ayahUrl = await _surahVerseByVerseViewModel.getAyahAudio(
            surahNo: widget.id,
            ayahNo: index + 1,
            kariId: selectKariId!,
          );
          if (ayahUrl != "hata") {
            _surahVerseByVerseViewModel.playUrlSingleAyah(url: ayahUrl);
          }

          print(index);
          }else{
            print("Bağlantı Yok");
           
             getDialog(
        context: context,
        title: "İnternet Bağlantısı Yok",
        content: Icon(Icons.wifi_off),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Tamam"),
          ),
        ],
      );
           
          }
         
        });
      
    
    
  }

  IconButonWidget shareButtonWidget(int index) {
    return IconButonWidget(
        icon: Icons.share_rounded,
        voidCallback: () {
          Share.share(
              "${ayahs[index].verse} \n \n ${ayahs[index].translation!.text}");
        });
  }

  IconButonWidget kaldigimYerButtonWidget(int index, BuildContext context) {
    return IconButonWidget(
        icon: _surahVerseByVerseViewModel.isFavoriControl(
                ayahNo: index + 1,
                surahNo: widget.id,
                box: HiveBoxes.kaldigimyerBox())
            ? Icons.bookmark
            : Icons.bookmark_add_outlined /* star */,
        voidCallback: () async {
          bool isFavori = await _surahVerseByVerseViewModel.isFavori(
              surahNo: widget.id,
              ayahNo: index + 1,
              box: HiveBoxes.kaldigimyerBox());
          if (!isFavori) {
            _favoriAyetlerimViewModel.addFovoriAyetim(
                arabicText: ayahs[index].verse.toString(),
                latinText: ayahs[index].transcription.toString(),
                turkishText: ayahs[index].translation!.text.toString(),
                surahNo: widget.id,
                ayahNo: index + 1,
                surahName: widget.surahName,
                box: HiveBoxes.kaldigimyerBox());

            SnippetExtanstion(context)
                .showToast("Kaldığın Yer Kayıt Edildi.", duration: 3);
          } else {
            SnippetExtanstion(context)
                .showToast("Kaldığın Yer Kaldırıldı", duration: 3);
          }

          setState(() {});
        });
  }

  IconButonWidget favoriButton(int index, BuildContext context) {
    return IconButonWidget(
        icon: _surahVerseByVerseViewModel.isFavoriControl(
                ayahNo: index + 1,
                surahNo: widget.id,
                box: HiveBoxes.faroviAyetlerimBox())
            ? Icons.star
            : Icons.star_outline /* star */,
        voidCallback: () async {
          bool isFavori = await _surahVerseByVerseViewModel.isFavori(
              surahNo: widget.id,
              ayahNo: index + 1,
              box: HiveBoxes.faroviAyetlerimBox());
          if (!isFavori) {
            _favoriAyetlerimViewModel.addFovoriAyetim(
                arabicText: ayahs[index].verse.toString(),
                latinText: ayahs[index].transcription.toString(),
                turkishText: ayahs[index].translation!.text.toString(),
                surahNo: widget.id,
                ayahNo: index + 1,
                surahName: widget.surahName,
                box: HiveBoxes.faroviAyetlerimBox());

            SnippetExtanstion(context).showToast(
                "Ayet Favorileri Ayetlerime Kayıt Edildi.",
                duration: 3);
          } else {
            SnippetExtanstion(context)
                .showToast("Fovorim Kaldırıldı", duration: 3);
          }

          setState(() {});
        });
  }
}
