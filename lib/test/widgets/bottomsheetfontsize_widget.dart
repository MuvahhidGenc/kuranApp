import 'package:flutter/material.dart';
import 'package:kuran/test/viewmodel/followquran_viewmodel.dart';
import 'package:provider/provider.dart';

class BottomSheetFontSizeWidget extends StatelessWidget {
  const BottomSheetFontSizeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<FollowQuranViewModel>();
    return Container(
      height: 75,
      child: Slider.adaptive(
        min: 17,
        value: provider.fontSize,
        max: 40,
        onChanged: (double value) => provider.setTextFontSize(value),
      ),
    );
  }
}
