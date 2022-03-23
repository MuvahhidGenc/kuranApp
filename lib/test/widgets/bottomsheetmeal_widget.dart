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
    provider.getTranslation();
    return Container(
      height: media.size.height * 0.3,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Center(
                  child: Text(provider.ayahTranslation == null
                      ? ""
                      : provider.aktifSurahName.toUpperCase() + " SÜRESİ"),
                ),
                Divider(
                  height: 20,
                ),
                Center(
                  child: Text(provider.ayahTranslation == null
                      ? ""
                      : provider.aktifsurah.toString() +
                          " - ) " +
                          provider.ayahTranslation!),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(provider.ayahTranslation == null
                      ? ""
                      : "Çeviri : Ali BULAÇ"),
                ),
              ],
            ),
          )
        ],
      ),
      //color: theme.backgroundColor,
    );
  }
}
