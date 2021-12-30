import 'package:flutter/material.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/test/viewmodel/trar_mp3_viewmodel.dart';
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
    return Container(
      //color: SnippetExtanstion(context).theme.scaffoldBackgroundColor,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.23,
      decoration: BoxDecoration(
          color: SnippetExtanstion(context).theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: SnippetExtanstion(context).theme.scaffoldBackgroundColor,
                spreadRadius: 3,
                blurRadius: 3.0)
          ]),
      child: Column(
        children: [
          // Text(
          //     "${_kariKuranMp3ModelView.getKari['surahName'] != null ? "Sure : " + _kariKuranMp3ModelView.getKari["surahName"].toUpperCase() : ''}",
          //     style: TextStyle(
          //       fontSize: 20,
          //     )),
          Divider(
            height: 10,
            color: SnippetExtanstion(context).theme.primaryColor,
          ),
          Padding(
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
                    Expanded(
                        child: Slider.adaptive(
                            value: trArViewModelProvider.position.inSeconds
                                .toDouble(),
                            max: trArViewModelProvider.duration.inSeconds
                                .toDouble(),
                            onChanged: (val) {
                              final durations = trArViewModelProvider.duration;
                              if (durations == null) {
                                return;
                              }
                              final positions = val;
                              if (positions <
                                  trArViewModelProvider.duration.inSeconds
                                      .toDouble())
                                trArViewModelProvider.audioPlayer
                                    .seek(Duration(seconds: positions.round()));
                            })),
                    Text(
                        "${trArViewModelProvider.duration.inMinutes}:${trArViewModelProvider.duration.inSeconds.remainder(60)}"),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Row(
                children: [
                  SizedBox(
                    height: 0,
                  ),
                  Expanded(
                    // skip Previous Button
                    child: IconButton(
                        onPressed: () async => await trArViewModelProvider
                            .bottomSheetNextAndBack(work: "previouse"),
                        icon: Icon(
                          Icons.skip_previous,
                          size: 35.0,
                        )),
                  ),
                  Expanded(
                    //Play Buttom
                    child: IconButton(
                        onPressed: () async => await trArViewModelProvider
                            .bottomSheetPlayButtonClick(),
                        icon: Icon(
                          trArViewModelProvider.buttomSheetPlayIcon ??
                              Icons.play_circle,
                          size: 50.0,
                        )),
                  ),
                  Expanded(
                    //Next Buttom
                    child: IconButton(
                        onPressed: () async => await trArViewModelProvider
                            .bottomSheetNextAndBack(work: "next"),
                        icon: Icon(
                          Icons.skip_next,
                          size: 35.0,
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
