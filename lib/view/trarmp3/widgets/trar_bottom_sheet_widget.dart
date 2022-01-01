import 'package:flutter/material.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/view/trarmp3/viewmodel/trar_mp3_viewmodel.dart';
import 'package:provider/provider.dart';

class TrArBottomSheetWidget extends StatefulWidget {
  const TrArBottomSheetWidget({Key? key}) : super(key: key);

  @override
  _TrArBottomSheetWidgetState createState() => _TrArBottomSheetWidgetState();
}

class _TrArBottomSheetWidgetState extends State<TrArBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    var trArViewModelProvider = Provider.of<TrArMp3ViewModel>(context);
    var mediaQuery = SnippetExtanstion(context).media;
    return Container(
      //color: SnippetExtanstion(context).theme.scaffoldBackgroundColor,
      width: mediaQuery.size.width,
      height: mediaQuery.size.height * 0.17,
      decoration: containerBoxDecoration(context),
      child: Column(
        children: [
          sliderAndLefRightTextWidgets(trArViewModelProvider),
          bottomButtonWidgets(trArViewModelProvider),
        ],
      ),
    );
  }

  Center bottomButtonWidgets(TrArMp3ViewModel trArViewModelProvider) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Row(
          children: [
            SizedBox(
              height: 0,
            ),
            previouseIconButon(trArViewModelProvider),
            playIconButonWidget(trArViewModelProvider),
            nextIconButonWidget(trArViewModelProvider)
          ],
        ),
      ),
    );
  }

  Expanded nextIconButonWidget(TrArMp3ViewModel trArViewModelProvider) {
    return Expanded(
      //Next Buttom
      child: IconButton(
          onPressed: () async =>
              await trArViewModelProvider.bottomSheetNextAndBack(work: "next"),
          icon: Icon(
            Icons.skip_next,
            size: 35.0,
          )),
    );
  }

  Expanded playIconButonWidget(TrArMp3ViewModel trArViewModelProvider) {
    return Expanded(
      //Play Buttom
      child: IconButton(
          onPressed: () async =>
              await trArViewModelProvider.bottomSheetPlayButtonClick(),
          icon: Icon(
            trArViewModelProvider.buttomSheetPlayIcon ?? Icons.play_circle,
            size: 50.0,
          )),
    );
  }

  Expanded previouseIconButon(TrArMp3ViewModel trArViewModelProvider) {
    return Expanded(
      // skip Previous Button
      child: IconButton(
          onPressed: () async => await trArViewModelProvider
              .bottomSheetNextAndBack(work: "previouse"),
          icon: Icon(
            Icons.skip_previous,
            size: 35.0,
          )),
    );
  }

  Padding sliderAndLefRightTextWidgets(TrArMp3ViewModel trArViewModelProvider) {
    return Padding(
      // Audio Slider Bar Left Right Text
      padding: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 0.0,
      ),
      child: Column(
        // Audio Sl
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                  "${trArViewModelProvider.position.inMinutes}:${trArViewModelProvider.position.inSeconds.remainder(60)}"),
              Expanded(child: sliderAdaptiveWidget(trArViewModelProvider)),
              Text(
                  "${trArViewModelProvider.duration.inMinutes}:${trArViewModelProvider.duration.inSeconds.remainder(60)}"),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration containerBoxDecoration(BuildContext context) {
    return BoxDecoration(
        color: SnippetExtanstion(context).theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: SnippetExtanstion(context).theme.scaffoldBackgroundColor,
              spreadRadius: 3,
              blurRadius: 3.0)
        ]);
  }

  Slider sliderAdaptiveWidget(TrArMp3ViewModel trArViewModelProvider) {
    return Slider.adaptive(
        value: trArViewModelProvider.position.inSeconds.toDouble(),
        max: trArViewModelProvider.duration.inSeconds.toDouble(),
        onChanged: (val) {
          final durations = trArViewModelProvider.duration;
          if (durations == null) {
            return;
          }
          final positions = val;
          if (positions < trArViewModelProvider.duration.inSeconds.toDouble())
            trArViewModelProvider.audioPlayer
                .seek(Duration(seconds: positions.round()));
        });
  }
}
