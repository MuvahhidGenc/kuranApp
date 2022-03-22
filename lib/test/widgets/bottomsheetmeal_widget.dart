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

    print(provider.getTexts[provider.aktifsurah - 1].number);
    print(provider.getTexts[provider.aktifsurah - 1].surah!.number);
    return Container(
      height: media.size.height * 0.3,
      child: ListView(
        children: [
          Text(provider.getTexts[provider.aktifsurah - 1] == null
              ? ""
              : provider.getTexts[provider.aktifsurah - 1].text!)
        ],
      ),
      //color: theme.backgroundColor,
    );
  }
}
