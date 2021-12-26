import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/globals/extantions/hivedb.dart';
import 'package:kuran/globals/manager/filepath_manager.dart';
import 'package:kuran/globals/manager/network_manager.dart';
import 'package:kuran/test/viewmodel/karikuranmp3_modelview.dart';
import 'package:kuran/view/karikuranmp3/model/kari_kuran_mp3_model.dart';
import 'package:kuran/view/karikuranmp3/modelview/karikuranmp3_modelview.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';

class TestKariKuranMp3View extends StatefulWidget {
  const TestKariKuranMp3View({Key? key}) : super(key: key);

  @override
  _TestKariKuranMp3ViewState createState() => _TestKariKuranMp3ViewState();
}

class _TestKariKuranMp3ViewState extends State<TestKariKuranMp3View> {
  final _kariKuranMp3ModelView = TestKariKuranMp3ModelView();

  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  PlayerState _audioPlayerState = PlayerState.STOPPED;
  Map<String, bool> audioPathState = Map<String, bool>();

  // KariKuranMp3Model? hafizlar;
  // String fileName = "hafizlar.json";
  // String sureListName = "surelist.json";
  // var _sureNameModel = SureNameModel();

  // Map<String, Widget> pathStateWidget =
  //     Map<String, Widget>(); //List Tile Path State Control And

  // Map<String, dynamic> kari = Map<String, dynamic>(); //Selected Kari Data
  // //Kari Hive Keys
  // Map<String, dynamic> hiveKey = {
  //   "kariId": "kariId",
  //   "kariName": "kariName",
  //   "kariUrl": "kariUrl",
  //   "kariSurahs": "kariSurahs"
  // };

  List<dynamic> kariSurahlist = List<int>.empty(growable: true);
  //Map<int, bool> playerControl = Map<int, bool>();
  IconData? rightIcon;
  IconData? buttomSheetPlayIcon;
  int say = 0;

  Duration duration = Duration();
  Duration position = Duration();
  double? pos;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _kariKuranMp3ModelView.initAsyc();
    audioPlayerStream();
  }

  /*Future initAsyc() async {
    dynamic v = KuranModelView().dbKeyControl(hiveKey["kariUrl"]);
    if (v == null) {
      HiveDb().putBox(hiveKey["kariUrl"], "https://server7.mp3quran.net/basit");
      HiveDb().putBox(hiveKey["kariName"], "Abdulbasit Abdulsamad");
      HiveDb().putBox(hiveKey["kariSurahs"],
          "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114");
      kari["name"] = await HiveDb().getBox(hiveKey["kariName"]);
      kari["surahs"] = await HiveDb().getBox(hiveKey["kariSurahs"]);
    } else {
      kari["name"] = await HiveDb().getBox(hiveKey["kariName"]);
      kari["surahs"] = await HiveDb().getBox(hiveKey["kariSurahs"]);
      setState(() {
        kari;
        kari["name"].toString().toLowerCase().trim();
        // kariSurahs;
        // kariName!.toLowerCase().trim();
      });
    }
    // _kariKuranMp3ModelView.downloadHafizlar(kari);
    downloadHafizlar();
    audioPlayerStream();
  }*/

  audioPlayerStream() {
    audioPlayer.onDurationChanged.listen((Duration d) {
      //print('Max duration: $d');
      setState(() => duration = d);
    });

    var posControl = false;
    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      /*print('Max duration: ${p.inMinutes}:${p.inSeconds}' +
          " Duration : ${duration.inMinutes}: ${duration.inSeconds}");*/
      if (p.inSeconds == duration.inSeconds - 1 ||
          p.inSeconds == duration.inSeconds) {
        audioNextAndPrevious(progress: "next");
      }
      setState(() {
        position = p;
      });
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _audioPlayerState = state;
        });
      }
    });
  }

  /* Future kariUpdate() async {
    for (var i = 0; i < _sureNameModel.data!.length; i++) {
      String surestring =
          _kariKuranMp3ModelView.toStringMp3(i: i, url: false, kari: kari);
      bool pathState = await FilePathManager().getFilePathControl(surestring);

      if (pathState != true) {
        pathStateWidget[surestring] = Icon(Icons.download);
      }
      audioPathState[surestring] = pathState;
    }
  }*/

  /* Future downloadHafizlar() async {
    // Get Kari
    String? path = DirectoryNameEnum(DirectoryName.kiraat).getjsonPath;
    dynamic getHafizlar = await NetworkManager().saveStorage(
        url: UrlsConstant.KURAN_MP3_URL, folder: path, fileName: fileName);
    hafizlar = KariKuranMp3Model.fromJson(jsonDecode(jsonDecode(getHafizlar)));

//Get List Surah Names
    var getSureName = await NetworkManager().saveStorage(
        url: UrlsConstant.ACIK_KURAN_URL + "/surahs",
        folder: DirectoryNameEnum(DirectoryName.surenamelist).getjsonPath,
        fileName: sureListName);

    _sureNameModel = SureNameModel.fromJson(jsonDecode(getSureName));
    //_sureNameModel=Sure

    await kariUpdate();

    _sureNameModel.data!.map((e) async {
      playerControl[say] = false;
      say++;
    }).toList();

    setState(() {
      pathStateWidget;
      audioPathState;
      hafizlar;
      _sureNameModel;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Center(child: Text(_kariKuranMp3ModelView.getKari["name"] ?? "")),
      ),
      endDrawer: drawer(),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: _kariKuranMp3ModelView.getsuraNameModel.data != null &&
                    kariSurahlist != null
                ? sureListViewBuilder()
                : Center(child: Text("Yükleniyor")),
          ),
          Expanded(flex: 3, child: SizedBox())
        ],
      ),
      bottomSheet: bottomSheetWidget(context),
      /* floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: kari["name"] != null
            ? FloatingActionButton(
                onPressed: () async {
                  for (var i = 0; i < kariSurahlist.length; i++) {
                    String surahToString = toStringMp3(i: i, url: false);
                    String webServisUrl = toStringMp3(i: i, url: true);
                    downloadAndAudioPlaySettings(
                        surahToString, webServisUrl, i);
                  }
                },
                child: Icon(
                  Icons.downloading,
                ),
              )
            : null,
      ),*/
    );
  }

  Container bottomSheetWidget(BuildContext context) {
    //BottomSheet
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
          Text(
              "${_kariKuranMp3ModelView.getKari['surahName'] != null ? "Sure : " + _kariKuranMp3ModelView.getKari["surahName"].toUpperCase() : ''}",
              style: TextStyle(
                fontSize: 20,
              )),
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
                        "${position.inMinutes}:${position.inSeconds.remainder(60)}"),
                    Expanded(
                        child: Slider.adaptive(
                            value: position.inSeconds.toDouble(),
                            max: duration.inSeconds.toDouble(),
                            onChanged: (val) {
                              final durations = duration;
                              if (durations == null) {
                                return;
                              }
                              final positions = val;
                              // if (positions < duration.inSeconds.toDouble())
                              audioPlayer
                                  .seek(Duration(seconds: positions.round()));
                            })),
                    Text(
                        "${duration.inMinutes}:${duration.inSeconds.remainder(60)}"),
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
                          await audioNextAndPrevious(progress: "previous");
                        },
                        icon: Icon(
                          Icons.skip_previous,
                          size: 35.0,
                        )),
                  ),
                  Expanded(
                    //Play Buttom
                    child: IconButton(
                        onPressed: () {
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
                        },
                        icon: Icon(
                          buttomSheetPlayIcon ?? Icons.play_circle_fill,
                          size: 50.0,
                        )),
                  ),
                  Expanded(
                    //Next Buttom
                    child: IconButton(
                        onPressed: () async {
                          await audioNextAndPrevious(progress: "next");
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

  Future<void> audioNextAndPrevious({String? progress}) async {
    int getIndex = _kariKuranMp3ModelView
        .getKariSurahListIndex(_kariKuranMp3ModelView.getKari);
    var firstIndex = getIndex;
    progress == "next" ? getIndex += 1 : getIndex -= 1;
    if (_kariKuranMp3ModelView.getKari["surah"] != null && getIndex >= 0) {
      String sureToString = _kariKuranMp3ModelView.toStringMp3(
          i: kariSurahlist[getIndex] - 1,
          url: false,
          kari: _kariKuranMp3ModelView.getKari);
      String webServisUrl = _kariKuranMp3ModelView.toStringMp3(
          i: kariSurahlist[getIndex] - 1,
          url: true,
          kari: _kariKuranMp3ModelView.getKari);

      print(kariSurahlist[getIndex]);

      var isPath = await FilePathManager().getFilePath(sureToString);

      if (isPath != "") {
        _kariKuranMp3ModelView.getKari["surah"] = kariSurahlist[getIndex];
        _kariKuranMp3ModelView.getPlayerControl.forEach((key, value) {
          _kariKuranMp3ModelView.getPlayerControl[key] = false;
        });

        audioPlayer.stop();
        buttomSheetPlayIcon = Icons.pause_circle_filled;
        audioPlayer.play(isPath);
        _kariKuranMp3ModelView
                .getPlayerControl[_kariKuranMp3ModelView.getKari["surah"] - 1] =
            true;

        _kariKuranMp3ModelView.getKari["surahName"] = _kariKuranMp3ModelView
            .getsuraNameModel
            .data![_kariKuranMp3ModelView.getKari["surah"] - 1]
            .name;
      } else {
        await downloadAndAudioPlaySettings(
            sureToString, webServisUrl, getIndex);
      }
    }
  }

  /*int getKariSurahListIndex() {
    var getIndex = kariSurahlist.indexOf(kari["surah"]);
    return getIndex;
  }*/

  Drawer drawer() {
    return Drawer(
      child: ListView(
        children: [
          Padding(padding: EdgeInsets.only(top: 10)),
          kariExpansionTile(),
        ],
      ),
    );
  }

  ExpansionTile kariExpansionTile() {
    return ExpansionTile(
      leading: Icon(Icons.person),
      title: Text("KARİ'LER"),
      children: _kariKuranMp3ModelView.getHafizlar != null
          ? _kariKuranMp3ModelView.getHafizlar.reciters.map<Card>((e) {
              return Card(
                child: ListTile(
                  leading: Icon(Icons.mic_external_on),
                  title: Text(e.name!),
                  trailing: Text("Sure : ${e.count}"),
                  onTap: () async {
                    HiveDb()
                        .putBox(_kariKuranMp3ModelView.hiveKey["kariId"], e.id);
                    HiveDb().putBox(
                        _kariKuranMp3ModelView.hiveKey["kariUrl"], e.server);
                    HiveDb().putBox(
                        _kariKuranMp3ModelView.hiveKey["kariName"], e.name);
                    HiveDb().putBox(
                        _kariKuranMp3ModelView.hiveKey["kariSurahs"], e.suras);
                    _kariKuranMp3ModelView.getKari["surahs"] = e.suras;
                    _kariKuranMp3ModelView.getKari["name"] = e.name;
                    await _kariKuranMp3ModelView.kariUpdate();
                    setState(() {
                      _kariKuranMp3ModelView.getKari["name"]
                          .toString()
                          .toLowerCase()
                          .trim();
                      _kariKuranMp3ModelView.getKari["surahs"];
                      audioPathState;
                      _kariKuranMp3ModelView.getPathStateWidget;
                    });
                    // print(e.suras);

                    // print(list.contains(1));
                    Navigator.pop(context);
                  },
                ),
              );
            }).toList(growable: true)
          : [Text("Yükleniyor")],
    );
  }

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

  Future<void> downloadAndAudioPlaySettings(
      String surahToString, String webServisUrl, int index) async {
    var getSurahIndex = _kariKuranMp3ModelView
        .getKariSurahListIndex(_kariKuranMp3ModelView.getKari);
    _kariKuranMp3ModelView.getPlayerControl.forEach((key, value) {
      _kariKuranMp3ModelView.getPlayerControl[key] = false;
    });
    if (audioPathState[surahToString] == false) {
      setState(() {
        _kariKuranMp3ModelView.getPathStateWidget[surahToString] =
            CircularProgressIndicator();
      });
    }
    audioPlayer.stop();
    //Kari Keep Veriable
    _kariKuranMp3ModelView.getKari["url"] =
        await HiveDb().getBox(_kariKuranMp3ModelView.hiveKey["kariUrl"]);
    _kariKuranMp3ModelView.getKari["url"] =
        _kariKuranMp3ModelView.getKari["url"]! + "/" + webServisUrl;

    var path = await NetworkManager().downloadMediaFile(
        url: _kariKuranMp3ModelView.getKari["url"],
        folderandpath: surahToString);

    //Kari Keep Veriable
    _kariKuranMp3ModelView.getKari["name"] =
        await HiveDb().getBox(_kariKuranMp3ModelView.hiveKey["kariName"]);
    _kariKuranMp3ModelView.getKari["path"] = path;
    _kariKuranMp3ModelView.getKari["surah"] = index + 1;
    _kariKuranMp3ModelView.getKari["surahName"] =
        _kariKuranMp3ModelView.getsuraNameModel.data![index].name;

    _kariKuranMp3ModelView.getPathStateWidget[surahToString] =
        Icon(Icons.download);
    audioPathState[surahToString] = true;

    if (_kariKuranMp3ModelView.getPlayerControl[index] == true) {
      buttomSheetPlayIcon = Icons.play_circle_fill;
      audioPlayer.pause();
    } else {
      _kariKuranMp3ModelView.getPlayerControl[index] = true;
      audioPlayer.play(path);
      buttomSheetPlayIcon = Icons.pause_circle_filled;
    }
    setState(() {
      audioPathState;
      _kariKuranMp3ModelView.getPlayerControl;
    });
  }
}
