import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/globals/widgets/ayahcontainerintext_widget.dart';
import 'package:kuran/globals/widgets/iconbuton_widget.dart';
import 'package:kuran/test/model/hive_favorilerim_model.dart';
import 'package:kuran/test/snippet/hive_boxes.dart';
import 'package:kuran/test/view/meal_detail_view.dart';
import 'package:share/share.dart';

class FavoriAyetlerimView extends StatefulWidget {
  FavoriAyetlerimView({Key? key}) : super(key: key);

  @override
  State<FavoriAyetlerimView> createState() => _FavoriAyetlerimViewState();
}

class _FavoriAyetlerimViewState extends State<FavoriAyetlerimView> {
  final Box<HiveFavorilerimModel>? _favoriBox = HiveBoxes.faroviAyetlerimBox();

  @override
  Widget build(BuildContext context) {
    var theme = SnippetExtanstion(context).theme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Favori Ayetlerim"),
      ),
      body: ValueListenableBuilder<Box<HiveFavorilerimModel>>(
          valueListenable: _favoriBox!.listenable(),
          builder: (context, box, widget) {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    title: Column(
                      children: [
                        Container(
                          alignment: Alignment.topRight,
                          child: IconButonWidget(
                              icon: Icons.close /* star */,
                              voidCallback: () {
                                print(box.keys.elementAt(i));
                                setState(() {
                                  box.delete(box.keys.elementAt(i));
                                });
                                SnippetExtanstion(context).showToast(
                                    "Favori Kaldırıldı",
                                    duration: 2);
                              }),
                        ),
                        AyahCardInTextWidget(
                          color: theme.focusColor,
                          ayah: _favoriBox!.values.elementAt(i).arabicText!,
                          textPosition: Alignment.topRight,
                          style: TextStyle(fontSize: 22),
                        ),
                        dividerWidget(),
                        AyahCardInTextWidget(
                          color: theme.focusColor,
                          ayah: _favoriBox!.values.elementAt(i).latinText!,
                          textPosition: Alignment.topLeft,
                        ),
                        dividerWidget(),
                        AyahCardInTextWidget(
                          color: theme.focusColor,
                          ayah: "${_favoriBox!.values.elementAt(i).ayahNo} - " +
                              _favoriBox!.values.elementAt(i).turkishText!,
                          textPosition: Alignment.topLeft,
                        ),
                        dividerWidget(),
                        AyahCardInTextWidget(
                          color: Colors.transparent,
                          ayah: _favoriBox!.values
                                  .elementAt(i)
                                  .surahName
                                  .toString() +
                              " / ${_favoriBox!.values.elementAt(i).ayahNo} ",
                          textPosition: Alignment.center,
                        ),
                        bottomButonWidgets(theme, i),
                      ],
                    ),
                  ),
                );
              },
            );
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
          IconButonWidget(
              icon: Icons.share_rounded,
              voidCallback: () {
                Share.share(
                    "${_favoriBox!.values.elementAt(index).arabicText} \n \n ${_favoriBox!.values.elementAt(index).turkishText} \n \n ${_favoriBox!.values.elementAt(index).surahName}");
              }),
          IconButonWidget(
              icon: Icons.arrow_right_alt /* star */,
              voidCallback: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MealDetailView(
                          id: _favoriBox!.values
                              .elementAt(index)
                              .surahNo!
                              .toInt(),
                          surahName: _favoriBox!.values
                              .elementAt(index)
                              .surahName
                              .toString(),
                          gotoAyah: _favoriBox!.values
                              .elementAt(index)
                              .ayahNo!
                              .toInt(),
                        )));
              }),
        ],
      ),
    );
  }
}
