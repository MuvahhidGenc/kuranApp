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
      //color: theme.backgroundColor,
    );
  }
}
