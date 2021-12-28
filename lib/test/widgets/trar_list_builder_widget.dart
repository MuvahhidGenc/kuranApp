import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/test/viewmodel/trar_mp3_viewmodel.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';
import 'package:provider/provider.dart';

class TrArListBuilderWidget extends StatefulWidget {
  SureNameModel sureNameModel;
  /* Map<int, bool> playController;
  Map<int, dynamic> audioPathController;
  Map<int, dynamic> downloadingWidgetState;*/
  TrArListBuilderWidget(this.sureNameModel, {Key? key}) : super(key: key);

  @override
  _TrArListBuilderWidgetState createState() => _TrArListBuilderWidgetState();
}

class _TrArListBuilderWidgetState extends State<TrArListBuilderWidget> {
  AudioPlayer _audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<TrArMp3ViewModel>(context, listen: false)
        .createAudioPathControl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TrArMp3ViewModel>(context);
    dynamic snipperTheme = SnippetExtanstion(context).theme;
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.sureNameModel.data?.length,
      itemBuilder: (context, int index) {
        return Card(
          child: ListTile(
            tileColor: provider.playController[index] == true
                ? snipperTheme.primaryColor
                : snipperTheme.listTileTheme.tileColor,
            leading: const Icon(Icons.headphones),
            title: Text(widget.sureNameModel.data![index].name.toString()),
            trailing: Wrap(
              spacing: 12,
              children: [
                provider.audioPathController[index] == true
                    ? provider.playController[index] != true
                        ? const Icon(Icons.play_circle)
                        : const Icon(Icons.pause_circle)
                    : const Text(""),
                provider.audioPathController[index] != true
                    ? provider.downloadControlWidget[index] != null
                        ? provider.downloadControlWidget[index] as Widget
                        : Text("") //Text("")
                    : const Text(""),
              ],
            ),
            onTap: () async {
              //await provider.getPlayController(index: index);
              String path = await provider.downloadingAudio(index);
              await provider.getPlayController(index: index);
              if (provider.playController[index] == true)
                _audioPlayer.play(path);
              else {
                _audioPlayer.stop();
              }
            },
          ),
        );
      },
    );
  }

  Future<void> onTapButton(int index) async {}
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
