import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/test/model/hive_favorilerim_model.dart';
import 'package:kuran/test/snippet/hive_boxes.dart';
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
                          child: iconButonWidget(Icons.close /* star */, () {
                            setState(() {
                              box.delete(box.keys.elementAt(i));
                            });
                            print(box.keys.elementAt(i));
                            print("Favori Ayetim Silindi");
                          }),
                        ),
                        arabicTextWidget(theme, i),
                        dividerWidget(),
                        latinceTextWidget(theme, i),
                        dividerWidget(),
                        translationTextWidget(theme, i),
                        dividerWidget(),
                        surahNameAndNo(theme, i),
                        bottomButonWidgets(theme, i),
                        /*Text(box.get(i)!.arabicText.toString()),
                        Text(box.get(i)!.latinText.toString()),
                        Text(box.get(i)!.turkishText.toString()),*/
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
          iconButonWidget(Icons.share_rounded, () {
            Share.share(
                "${_favoriBox!.values.elementAt(index).arabicText} \n \n ${_favoriBox!.values.elementAt(index).turkishText}");
          }),
          iconButonWidget(Icons.arrow_right_alt /* star */, () {
            print("Ayete Git");
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
        child: Text("${_favoriBox!.values.elementAt(i).ayahNo}- " +
            _favoriBox!.values.elementAt(i).turkishText.toString()),
      ),
    );
  }

  Container surahNameAndNo(ThemeData theme, int i) {
    return Container(
      //color: theme.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(_favoriBox!.values.elementAt(i).surahNo.toString() +
            " / ${_favoriBox!.values.elementAt(i).ayahNo} "),
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
          _favoriBox!.values.elementAt(i).arabicText ?? "",
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
        child: Text(_favoriBox!.values.elementAt(i).latinText ?? ""),
      )),
    );
  }
}
