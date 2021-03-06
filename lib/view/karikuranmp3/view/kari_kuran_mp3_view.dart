import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/globals/extantions/hivedb.dart';
import 'package:kuran/globals/manager/filepath_manager.dart';
import 'package:kuran/globals/manager/network_manager.dart';
import 'package:kuran/globals/widgets/alertdialog_widget.dart';
import 'package:kuran/view/karikuranmp3/model/kari_kuran_mp3_model.dart';
import 'package:kuran/view/karikuranmp3/modelview/karikuranmp3_modelview.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';
import 'package:kuran/view/kuran/modelview/kuran_model_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class KariKuranMp3View extends StatefulWidget {
  const KariKuranMp3View({Key? key}) : super(key: key);

  @override
  _KariKuranMp3ViewState createState() => _KariKuranMp3ViewState();
}

class _KariKuranMp3ViewState extends State<KariKuranMp3View> {
  final _kariKuranMp3ModelView = KariKuranMp3ModelView();

  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  PlayerState _audioPlayerState = PlayerState.STOPPED;
  Map<String, bool> audioPathState = Map<String, bool>();

  Map<int, bool> downloading = Map<int, bool>();
  double progress = 0;
  // bool downloading = false;

  KariKuranMp3Model? hafizlar;
  String fileName = "hafizlar.json";
  String sureListName = "surelist.json";
  var _sureNameModel = SureNameModel();
  bool networkControl = true;

  Map<String, dynamic> kari = Map<String, dynamic>(); //Selected Kari Data
  //Kari Hive Keys
  Map<String, dynamic> hiveKey = {
    "kariId": "kariId",
    "kariName": "kariName",
    "kariUrl": "kariUrl",
    "kariSurahs": "kariSurahs"
  };

  List<dynamic> kariSurahlist = List<int>.empty(growable: true);
  Map<int, bool> playerControl = Map<int, bool>();
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
    audioPlayer.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("initState");

    initAsyc();
  }

  Future initAsyc() async {
    networkControl = true;
    Future.delayed(Duration(microseconds: 60), () async {
      networkControl = await NetworkManager().connectionControl();
    });

    dynamic v = await KuranModelView().dbKeyControl(hiveKey["kariUrl"]);
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
    /*WidgetsBinding.instance!.addPostFrameCallback((_)async {
       if(!networkControl){
        await getDialog(context: context, title: "title", actions: [TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("child"))]);
       }
  });*/
  }

  audioPlayerStream() {
    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() => duration = d);
    });

    var posControl = false;
    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      print('Max duration: ${p.inMinutes}:${p.inSeconds}' +
          " Duration : ${duration.inMinutes}: ${duration.inSeconds}");
      if (p.inSeconds == duration.inSeconds - 1 ||
          p.inSeconds == duration.inSeconds) {
        //audioNextAndPrevious(progress: "next");
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

  Future kariUpdate() async {
    for (var i = 0; i < _sureNameModel.data!.length; i++) {
      String surestring =
          _kariKuranMp3ModelView.toStringMp3(i: i, url: false, kari: kari);
      bool pathState = await FilePathManager().getFilePathControl(surestring);

      audioPathState[surestring] = pathState;
    }
  }

  Future downloadHafizlar() async {
    // Get Kari
    String? path = DirectoryNameEnum(DirectoryName.kiraat).getjsonPath;

    dynamic getHafizlar = await NetworkManager().saveStorage(
        url: UrlsConstant.KURAN_MP3_URL, folder: path, fileName: fileName);

//Get List Surah Names
    var getSureName = await NetworkManager().saveStorage(
        url: UrlsConstant.ACIK_KURAN_URL + "/surahs",
        folder: DirectoryNameEnum(DirectoryName.surenamelist).getjsonPath,
        fileName: sureListName);

    if (path != ExcationManagerEnum.notConnection &&
        getSureName != ExcationManagerEnum.notConnection) {
      networkControl = true;
      hafizlar =
          KariKuranMp3Model.fromJson(jsonDecode(jsonDecode(getHafizlar)));

      _sureNameModel = SureNameModel.fromJson(jsonDecode(getSureName));
      _sureNameModel.data!.map((e) async {
        playerControl[say] = false;
        say++;
      }).toList();
    } else {
      networkControl = false;
    }

    //_sureNameModel=Sure
    if (kari["name"] != null) {
      await kariUpdate();
    }

    setState(() {
      audioPathState;
      hafizlar;
      _sureNameModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = SnippetExtanstion(context).theme;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(kari["name"] ?? "Kari Se??imi Yap??n ->")),
      ),
      endDrawer: drawer(),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: surahNameNullControl(theme),

            /*AlertDialog(
                    title: Text("??nternet Ba??lant??n??z Yok"),
                    content: Icon(Icons.wifi_off),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Vazge??"),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      super.widget));
                        },
                        child: Text("Yenile"),
                      ),
                    ],
                  ),*/
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

  Widget surahNameNullControl(ThemeData theme) {
    if (_sureNameModel.data != null && kariSurahlist != null) {
      return sureListViewBuilder();
    } else {
      if (networkControl) {
        return ListView.builder(
            itemCount: 10,
            itemBuilder: (context, i) {
              return Card(
                child: ListTile(
                  tileColor: theme.scaffoldBackgroundColor,
                ),
              );
            });
      } else {
        return networkControlWidget();
      }
    }
  }

  Widget networkControlWidget() {
    return Center(
      child: Column(
        children: [
          Text("??nternet Ba??lant??s?? Olmad?????? ????in S??re ??simleri ??ndirilmedi.!"),
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => super.widget));
              },
              child: Text("Yeniden Dene"))
        ],
      ),
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
              "${kari['surahName'] != null ? "Sure : " + kari["surahName"].toUpperCase() : ''}",
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
                          size: 30.0,
                        )),
                  ),
                  Expanded(
                    //Play Buttom
                    child: IconButton(
                        onPressed: () {
                          if (_audioPlayerState == PlayerState.PLAYING) {
                            audioPlayer.pause();
                            buttomSheetPlayIcon = Icons.play_circle_fill;
                            playerControl[kari["surah"] - 1] = false;
                          } else if (_audioPlayerState == PlayerState.PAUSED) {
                            audioPlayer.resume();
                            buttomSheetPlayIcon = Icons.pause_circle_filled;
                            playerControl[kari["surah"] - 1] = true;
                          } else if (kari["path"] != null) {
                            playerControl[kari["surah"] - 1] = true;
                            audioPlayer.play(kari["path"]!);
                          }

                          setState(() {
                            buttomSheetPlayIcon;
                          });
                        },
                        icon: Icon(
                          buttomSheetPlayIcon ?? Icons.play_circle_fill,
                          size: 35.0,
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
                          size: 30.0,
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
    int getIndex = _kariKuranMp3ModelView.getKariSurahListIndex(kari);
    var firstIndex = getIndex;
    progress == "next" ? getIndex += 1 : getIndex -= 1;
    if (kari["surah"] != null && getIndex >= 0) {
      String sureToString = _kariKuranMp3ModelView.toStringMp3(
          i: kariSurahlist[getIndex] - 1, url: false, kari: kari);
      String webServisUrl = _kariKuranMp3ModelView.toStringMp3(
          i: kariSurahlist[getIndex] - 1, url: true, kari: kari);

      print(kariSurahlist[getIndex]);

      var isPath = await FilePathManager().getFilePath(sureToString);

      if (isPath != "") {
        kari["surah"] = kariSurahlist[getIndex];
        playerControl.forEach((key, value) {
          playerControl[key] = false;
        });

        audioPlayer.stop();
        buttomSheetPlayIcon = Icons.pause_circle_filled;
        audioPlayer.play(isPath);
        playerControl[kari["surah"] - 1] = true;

        kari["surahName"] = _sureNameModel.data![kari["surah"] - 1].name;
      } else {
        await downloadAndAudioPlaySettings(
            context, sureToString, webServisUrl, getIndex);
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
      title: Text("KAR??'LER"),
      children: hafizlar != null
          ? hafizlar!.reciters!.map<Card>((e) {
              return Card(
                child: ListTile(
                  leading: Icon(Icons.mic_external_on),
                  title: Text(e.name!),
                  trailing: Text("Sure : ${e.count}"),
                  onTap: () async {
                    HiveDb().putBox(hiveKey["kariId"], e.id);
                    HiveDb().putBox(hiveKey["kariUrl"], e.server);
                    HiveDb().putBox(hiveKey["kariName"], e.name);
                    HiveDb().putBox(hiveKey["kariSurahs"], e.suras);
                    kari["surahs"] = e.suras;
                    kari["name"] = e.name;
                    await kariUpdate();
                    setState(() {
                      kari["name"].toString().toLowerCase().trim();
                      kari["surahs"];
                      audioPathState;
                    });
                    // print(e.suras);

                    // print(list.contains(1));
                    Navigator.pop(context);
                  },
                ),
              );
            }).toList(growable: true)
          : [Text("Y??kleniyor")],
    );
  }

  Container sureListViewBuilder() {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: _sureNameModel.data!.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, int index) {
            kari["surahs"] != null
                ? kariSurahlist = _kariKuranMp3ModelView.createKariList(kari)
                // kari["surahs"]!.split(",").map(int.parse).toList()
                : null;

            if (kariSurahlist.contains(index + 1)) {
              //205,55,16
              String surahToString = _kariKuranMp3ModelView.toStringMp3(
                  i: index, url: false, kari: kari);

              String webServisUrl = _kariKuranMp3ModelView.toStringMp3(
                  i: index, url: true, kari: kari);

              return Card(
                child: ListTile(
                  tileColor: audioPathState[surahToString] != false
                      ? playerControl[index] == false
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
                  title: Text(_sureNameModel.data![index].name!),
                  trailing: Wrap(
                    spacing: 12, // space between two icons
                    children: <Widget>[
                      audioPathState[surahToString] != false
                          ? playerControl[index] == false
                              ? Icon(Icons.play_arrow)
                              : Icon(Icons.pause)
                          : Text(""),
                      if (audioPathState[surahToString] == false)
                        Icon(Icons.download),
                      if (audioPathState[surahToString] == false &&
                          downloading[index] == true)
                        CircularProgressIndicator(
                          value: progress,
                        )
                      /*audioPathState[surahToString] == false 
                          ? downloading==false? pathStateWidget[surahToString] as Widget
                          : Text(""),*/ // icon-2
                    ],
                  ),
                  onTap: () async {
                    bool path = await FilePathManager()
                        .getFilePathControl(surahToString);
                    if (!path) {
                      getDialog(
                        context: context,
                        title: "??ND??RME ??ZN??",
                        content: Text("??ndirme ????lemi Ba??at??ls??n M???"),
                        actions: [
                          TextButton.icon(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close),
                            label: Text("VAZGE??"),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              Navigator.pop(context);
                              await downloadAndAudioPlaySettings(
                                  context, surahToString, webServisUrl, index);
                            },
                            icon: Icon(Icons.downloading),
                            label: Text("??ND??R"),
                          ),
                        ],
                      );
                    } else {
                      await downloadAndAudioPlaySettings(
                          context, surahToString, webServisUrl, index);
                    }
                  },
                ),
              );
            } else {
              return SizedBox();
            }
          }),
    );
  }

  Future downloadFile(BuildContext context,
      {required String url,
      required String fileName,
      required int downloadingIndex}) async {
    Dio dio = Dio();
    var dir = await getApplicationDocumentsDirectory();
    var path = "${dir.path}/$fileName";
    var pathState = File(path);
    if (!pathState.existsSync()) {
      await dio.download(url, path, onReceiveProgress: (rec, total) {
        downloading[downloadingIndex] = true;
        progress = ((rec / total));
        print(progress);
       
        setState(() {});
      }).then((value) => value.statusCode != 200
          ? pathState.delete()
          : downloading[downloadingIndex] = false);
    }

    return path;
  }

  Future<void> downloadAndAudioPlaySettings(BuildContext context,
      String surahToString, String webServisUrl, int index) async {
    progress = 0;
    //var networkProgressProvider = Provider.of<NetworkManager>(context);

    setState(() {});
    kari["url"] = await HiveDb().getBox(hiveKey["kariUrl"]);
    kari["url"] = kari["url"]! + "/" + webServisUrl;
    var path = await downloadFile(context,
        url: kari["url"], fileName: surahToString, downloadingIndex: index);

    if (path != ExcationManagerEnum.notConnection &&
        path != ExcationManagerEnum.downloadEroor) {
      var getSurahIndex = _kariKuranMp3ModelView.getKariSurahListIndex(kari);
      playerControl.forEach((key, value) {
        playerControl[key] = false;
      });

      audioPlayer.stop();
      //Kari Keep Veriable

      //Kari Keep Veriable
      kari["name"] = await HiveDb().getBox(hiveKey["kariName"]);
      kari["path"] = path;
      kari["surah"] = index + 1;
      kari["surahName"] = _sureNameModel.data![index].name;

      audioPathState[surahToString] = true;

      if (playerControl[index] == true) {
        buttomSheetPlayIcon = Icons.play_circle_fill;
        audioPlayer.pause();
      } else {
        playerControl[index] = true;
        audioPlayer.play(path);
        buttomSheetPlayIcon = Icons.pause_circle_filled;
      }
      setState(() {
        audioPathState;
        playerControl;
      });
    } else {
      getDialog(
        context: context,
        title: "??nternet Ba??lant??s?? Yok",
        content: Icon(Icons.wifi_off),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Tamam"),
          ),
        ],
      );
    }
  }
}
