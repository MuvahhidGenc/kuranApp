import 'package:flutter/material.dart';
import 'package:kuran/globals/extantions/extanstion.dart';

class TrArBottomSheetWidget extends StatefulWidget {
  const TrArBottomSheetWidget({Key? key}) : super(key: key);

  @override
  _TrArBottomSheetWidgetState createState() => _TrArBottomSheetWidgetState();
}

class _TrArBottomSheetWidgetState extends State<TrArBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
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
                    // Text(
                    //     "${position.inMinutes}:${position.inSeconds.remainder(60)}"),
                    Expanded(
                        child: Slider.adaptive(
                            value: 0, //position.inSeconds.toDouble(),
                            max: 100, //duration.inSeconds.toDouble(),
                            onChanged: (val) {
                              // final durations = duration;
                              // if (durations == null) {
                              //   return;
                              // }
                              // final positions = val;
                              // // if (positions < duration.inSeconds.toDouble())
                              // audioPlayer
                              //     .seek(Duration(seconds: positions.round()));
                            })),
                    // Text(
                    //     "${duration.inMinutes}:${duration.inSeconds.remainder(60)}"),
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
                        onPressed: () async {
                          // await audioNextAndPrevious(progress: "previous");
                        },
                        icon: Icon(
                          Icons.skip_previous,
                          size: 35.0,
                        )),
                  ),
                  Expanded(
                    //Play Buttom
                    child: IconButton(
                        onPressed: () {},
                        /* onPressed: () {
                          if (_audioPlayerState == PlayerState.PLAYING) {
                            audioPlayer.pause();
                            buttomSheetPlayIcon = Icons.play_circle_fill;
                            _kariKuranMp3ModelView.getPlayerControl[
                                _kariKuranMp3ModelView.getKari["surah"] -
                                    1] = false;
                          } else if (_audioPlayerState == PlayerState.PAUSED) {
                            audioPlayer.resume();
                            buttomSheetPlayIcon = Icons.pause_circle_filled;
                            _kariKuranMp3ModelView.getPlayerControl[
                                _kariKuranMp3ModelView.getKari["surah"] -
                                    1] = true;
                          } else if (_kariKuranMp3ModelView.getKari["path"] !=
                              null) {
                            _kariKuranMp3ModelView.getPlayerControl[
                                _kariKuranMp3ModelView.getKari["surah"] -
                                    1] = true;
                            audioPlayer
                                .play(_kariKuranMp3ModelView.getKari["path"]!);
                          }

                          setState(() {
                            buttomSheetPlayIcon;
                          });
                        },*/
                        icon: Icon(
                          //buttomSheetPlayIcon ??
                          Icons.play_circle_fill,
                          size: 50.0,
                        )),
                  ),
                  Expanded(
                    //Next Buttom
                    child: IconButton(
                        onPressed: () async {
                          //   await audioNextAndPrevious(progress: "next");
                        },
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
