import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/test/viewmodel/trar_mp3_viewmodel.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';

class TrArListBuilderWidget extends StatefulWidget {
  SureNameModel sureNameModel;
  Map<int, bool> playController;
  TrArListBuilderWidget(this.sureNameModel, this.playController);

  @override
  _TrArListBuilderWidgetState createState() => _TrArListBuilderWidgetState();
}

class _TrArListBuilderWidgetState extends State<TrArListBuilderWidget> {
  var _trArMp3ModelView = TrArMp3ViewModel();
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: widget.sureNameModel.data?.length,
      itemBuilder: (context, int index) {
        return Card(
          child: ListTile(
            leading: Icon(Icons.headphones),
            title: Text(widget.sureNameModel.data![index].name.toString()),
            trailing: widget.playController[index] != true
                ? Icon(Icons.play_circle)
                : Icon(Icons.pause_circle),
            onTap: () async {
              widget.playController =
                  await _trArMp3ModelView.getPlayController(index: index);
              String path = await _trArMp3ModelView.pathControllerAndDownload(
                  UrlsConstant.KURAN_MP3_TRAR_URL + "artukmp3/${index + 1}.mp3",
                  "trar_${index + 1}.mp3");
              // print(path);
              _trArMp3ModelView.audioPlay(path);

              setState(() {});
            },
          ),
        );
      },
    );
  }
}


/*
 Container sureListViewBuilder() {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: _kariKuranMp3ModelView.getsuraNameModel.data!.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, int index) {
            _kariKuranMp3ModelView.getKari["surahs"] != null
                ? kariSurahlist = _kariKuranMp3ModelView
                    .createKariList(_kariKuranMp3ModelView.getKari)
                // kari["surahs"]!.split(",").map(int.parse).toList()
                : null;

            if (kariSurahlist.contains(index + 1)) {
              //205,55,16
              String surahToString = _kariKuranMp3ModelView.toStringMp3(
                  i: index, url: false, kari: _kariKuranMp3ModelView.getKari);

              String webServisUrl = _kariKuranMp3ModelView.toStringMp3(
                  i: index, url: true, kari: _kariKuranMp3ModelView.getKari);

              return Card(
                child: ListTile(
                  tileColor: audioPathState[surahToString] != false
                      ? _kariKuranMp3ModelView.getPlayerControl[index] == false
                          ? SnippetExtanstion(context)
                              .theme
                              .listTileTheme
                              .tileColor
                          : SnippetExtanstion(context).theme.primaryColor
                      : SnippetExtanstion(context)
                          .theme
                          .listTileTheme
                          .tileColor,
                  leading: const Icon(Icons.headphones),
                  title: Text(_kariKuranMp3ModelView
                      .getsuraNameModel.data![index].name!),
                  trailing: Wrap(
                    spacing: 12, // space between two icons
                    children: <Widget>[
                      audioPathState[surahToString] != false
                          ? _kariKuranMp3ModelView.getPlayerControl[index] ==
                                  false
                              ? Icon(Icons.play_arrow)
                              : Icon(Icons.pause)
                          : Text(""),

                      audioPathState[surahToString] == false
                          ? _kariKuranMp3ModelView
                              .getPathStateWidget[surahToString] as Widget
                          : Text(""), // icon-2
                    ],
                  ),
                  onTap: () async {
                    await downloadAndAudioPlaySettings(
                        surahToString, webServisUrl, index);
                  },
                ),
              );
            } else {
              return SizedBox();
            }
          }),
    );
  }



 */
