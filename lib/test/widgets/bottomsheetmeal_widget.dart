import 'package:flutter/material.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/test/viewmodel/followquran_viewmodel.dart';
import 'package:provider/provider.dart';

class BottomSheetMealWidget extends StatelessWidget {
  const BottomSheetMealWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var theme = SnippetExtanstion(context).theme;
    var media = SnippetExtanstion(context).media;
    var provider = context.watch<FollowQuranViewModel>();
    return Container(
      height: media.size.height * 0.3,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child:provider.aktifsurah>0?  Column(
              children: [
               Center(
                  child: Text(provider.ayahTranslation.translation!.text == null
                      ? ""
                      : provider.aktifSurahName.toUpperCase() + " SÜRESİ",style: TextStyle(color: theme.listTileTheme.textColor),),
                ),
                Divider(
                  height: 20,
                ),
                Center(
                  child: Text(provider.ayahTranslation.translation!.text == null
                      ? ""
                      : provider.ayahTranslation.verseNumber.toString() +
                          " - ) " +
                          provider.ayahTranslation!.translation!.text,style: TextStyle(color: theme.listTileTheme.textColor),),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(provider.ayahTranslation.translation!.text == null
                      ? ""
                      : "Çeviri : Ali BULAÇ",style: TextStyle(color: theme.listTileTheme.textColor),),
                ),
              ],
            ):SizedBox(),
          )
        ],
      ),
      //color: theme.backgroundColor,
    );
  }
}
