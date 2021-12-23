import 'dart:convert';
import 'dart:ffi';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/globals/extantions/hivedb.dart';
import 'package:kuran/globals/manager/filepath_manager.dart';
import 'package:kuran/globals/manager/network_manager.dart';
import 'package:kuran/test/model/hafizlar_audio_model.dart';
import 'package:kuran/test/viewmodel/kariler_viewmodel.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';
import 'package:kuran/view/kuran/modelview/kuran_model_view.dart';

class AudioTestView extends StatefulWidget {
  const AudioTestView({Key? key}) : super(key: key);

  @override
  _AudioTestViewState createState() => _AudioTestViewState();
}

class _AudioTestViewState extends State<AudioTestView> {
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  PlayerState _audioPlayerState = PlayerState.STOPPED;
  Map<String, bool> audioPathState = Map<String, bool>();

  Hafizlar? hafizlar;
  String fileName = "hafizlar.json";
  String sureListName = "surelist.json";
  var _sureNameModel = SureNameModel();
  Map<String, Widget> pathStateWidget = Map<String, Widget>();
/* Hive Db Veriables */
  int? kariId;
  String? kariName, kariUrl, kariSurahs, kariPath;
  String hiveKeyKariId = "kariId",
      hiveKeyKariName = "kariName",
      hiveKeyKariUrl = "kariUrl",
      hiveKeyKariSurahs = "kariSurahs";

  List<dynamic> kariSurahlist = List<int>.empty(growable: true);
  Map<int, bool> playerControl = Map<int, bool>();
  IconData? rightIcon;
  int say = 0;

  Duration duration = Duration();
  Duration position = Duration();
  double? pos;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.stop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsyc();
  }

  Future initAsyc() async {
    dynamic v = KuranModelView().dbKeyControl(hiveKeyKariUrl);
    if (v == null) {
      HiveDb().putBox(hiveKeyKariUrl, "https://server7.mp3quran.net/basit");
      HiveDb().putBox(hiveKeyKariName, "Abdulbasit Abdulsamad");
      HiveDb().putBox(hiveKeyKariSurahs,
          "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114");
      kariName = await HiveDb().getBox(hiveKeyKariName);
      kariSurahs = await HiveDb().getBox(hiveKeyKariSurahs);
    } else {
      kariName = await HiveDb().getBox(hiveKeyKariName);
      kariSurahs = await HiveDb().getBox(hiveKeyKariSurahs);
      setState(() {
        kariSurahs;
        kariName!.toLowerCase().trim();
      });
    }
    downloadHafizlar();

    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() => duration = d);
    });

    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      print('Max duration: ${p.inMinutes}:${p.inSeconds}' +
          " Duration : ${duration.inMinutes}: ${duration.inSeconds}");
      pos = position.inSeconds.toDouble();
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
      String surestring = toStringMp3(i: i, url: false);

      //print(surestring);

      bool pathState = await FilePathManager().getFilePathControl(surestring);
      // print(path);

      // audioPathState.toList();
      if (pathState != true) {
        pathStateWidget[surestring] = Icon(Icons.download);
      }
      audioPathState[surestring] = pathState;

      print(i);
    }
  }

  Future downloadHafizlar() async {
    // Get Kari
    String? path = DirectoryNameEnum(DirectoryName.kiraat).getjsonPath;
    dynamic getHafizlar = await NetworkManager().saveStorage(
        url: UrlsConstant.KURAN_MP3_URL, folder: path, fileName: fileName);
    hafizlar = Hafizlar.fromJson(jsonDecode(jsonDecode(getHafizlar)));

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
  }

  String toStringMp3({int? i, bool? url}) {
    String surestring = (i! + 1).toString();
    if (surestring.length == 1) {
      surestring = "00" + surestring + ".mp3";
    } else if (surestring.length == 2) {
      surestring = "0" + surestring + ".mp3";
    } else {
      surestring += ".mp3";
    }
    if (url!) {
      return surestring;
    } else {
      return kariName! + surestring;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(kariName ?? "")),
      ),
      endDrawer: drawer(),
      body: Center(
        child: _sureNameModel.data != null && kariSurahlist != null
            ? sureListViewBuilder()
            : Center(child: Text("Yükleniyor")),
      ),
      bottomSheet: bottomSheetWidget(context),
    );
  }

  Container bottomSheetWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.16,
      color: Colors.lightBlueAccent,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
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
                          // if (positions > duration.inSeconds.toDouble())
                          audioPlayer
                              .seek(Duration(seconds: positions.round()));

                          // position.inSeconds = pos.;
                        })),
                Text(
                    "${duration.inMinutes}:${duration.inSeconds.remainder(60) - 1}"),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: Wrap(
              spacing: 25.0,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_left_outlined,
                      size: 50.0,
                    )),
                IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
                IconButton(onPressed: () {}, icon: Icon(Icons.arrow_right))
              ],
            ),
          ),

          //                             "${musicPosition.inMinutes}:${musicPosition.inSeconds.remainder(60)}",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w200,
//                             ),
//                           ),
//                           Expanded(
//                             child: Slider.adaptive(
//                               activeColor: Colors.white,
//                               inactiveColor: Colors.grey,
//                               value: musicPosition.inSeconds.toDouble(),
//                               max: musicDuration.inSeconds.toDouble(),
//                               onChanged: (val) {},
//                             ),
//                           ),
//                           Text(
//                             "${musicDuration.inMinutes}:${musicDuration.inSeconds.remainder(60)}",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w200,
//                             ),
        ],
      ),
      //  decoration: BoxDecoration(),
    );
  }

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
      children: hafizlar != null
          ? hafizlar!.reciters!.map<Card>((e) {
              return Card(
                child: ListTile(
                  leading: Icon(Icons.mic_external_on),
                  title: Text(e.name!),
                  trailing: Text("Sure : ${e.count}"),
                  onTap: () async {
                    HiveDb().putBox(hiveKeyKariId, e.id);
                    HiveDb().putBox(hiveKeyKariUrl, e.server);
                    HiveDb().putBox(hiveKeyKariName, e.name);
                    HiveDb().putBox(hiveKeyKariSurahs, e.suras);
                    kariSurahs = e.suras;
                    kariName = e.name;
                    await kariUpdate();
                    setState(() {
                      kariName!.toLowerCase().trim();
                      kariSurahs;
                      audioPathState;
                      pathStateWidget;
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

  ListView sureListViewBuilder() {
    return ListView.builder(
        itemCount: _sureNameModel.data!.length,
        itemBuilder: (context, int index) {
          kariSurahs != null
              ? kariSurahlist = kariSurahs!.split(",").map(int.parse).toList()
              : kariSurahs;

          if (kariSurahlist.contains(index + 1)) {
            //205,55,16
            String surahToString = toStringMp3(i: (index), url: false);

            String webServisUrl = toStringMp3(i: index, url: true);

            return Card(
              child: ListTile(
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

                    audioPathState[surahToString] == false
                        ? pathStateWidget[surahToString] as Widget
                        : Text(""), // icon-2
                  ],
                ),
                onTap: () async {
                  if (audioPathState[surahToString] == false) {
                    setState(() {
                      pathStateWidget[surahToString] =
                          CircularProgressIndicator();
                    });
                  }
                  audioPlayer.stop();
                  kariUrl = await HiveDb().getBox(hiveKeyKariUrl);
                  kariUrl = kariUrl! + "/" + webServisUrl;

                  var path = await NetworkManager().downloadMediaFile(
                      url: kariUrl, folderandpath: surahToString);

                  kariName = await HiveDb().getBox(hiveKeyKariName);
                  kariPath = path;

                  pathStateWidget[surahToString] = Icon(Icons.download);
                  audioPathState[surahToString] = true;

                  if (playerControl[index] == true) {
                    playerControl[index] = false;
                    audioPlayer.pause();
                  } else {
                    playerControl[index] = true;
                    audioPlayer.play(path);
                  }
                  setState(() {
                    audioPathState;
                    playerControl;
                  });
                },
              ),
            );
          } else {
            return SizedBox();
          }
        });
  }

  /* localFilePath != null
              ? TextButton(
                  onPressed: () {
                    audioPlayer.play(localFilePath!);
                  },
                  child: Icon(Icons.play_arrow),
                )
              : TextButton(
                  onPressed: () {
                    _loadFile(
                        "https://cdn.islamic.network/quran/audio/192/ar.abdulbasitmurattal/1.mp3",
                        "/audio.mp3");
                  },
                  child: Icon(Icons.play_arrow),
                )*/
  // );
}


// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';

// class AudioTestView extends StatefulWidget {
//   const AudioTestView({Key? key}) : super(key: key);

//   @override
//   _AudioTestViewState createState() => _AudioTestViewState();
// }

// class _AudioTestViewState extends State<AudioTestView> {
//   List musicList = [
//     {
//       "title": "Life is a Dream",
//       "artist": "Michael Ramir",
//       "cover":
//           "https://images.pexels.com/photos/1884306/pexels-photo-1884306.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//       "url":
//           "https://assets.mixkit.co/music/preview/mixkit-life-is-a-dream-837.mp3",
//     },
//     {
//       "title": "Feeling Happy",
//       "artist": "Ahjay Stelino",
//       "cover":
//           "https://images.pexels.com/photos/2682877/pexels-photo-2682877.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//       "url":
//           "https://assets.mixkit.co/music/preview/mixkit-feeling-happy-5.mp3",
//     },
//     {
//       "title": "Dance with Me",
//       "artist": "Ahjay Stelino",
//       "cover":
//           "https://images.pexels.com/photos/235615/pexels-photo-235615.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//       "url":
//           "https://assets.mixkit.co/music/preview/mixkit-dance-with-me-3.mp3",
//     },
//     {
//       "title": "Sleepy Cat",
//       "artist": "Alejandro Magaña",
//       "cover":
//           "https://images.pexels.com/photos/1122868/pexels-photo-1122868.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//       "url": "https://assets.mixkit.co/music/preview/mixkit-sleepy-cat-135.mp3",
//     },
//     {
//       "title": "Delightful",
//       "artist": "Ahjay Stelino",
//       "cover":
//           "https://images.pexels.com/photos/259707/pexels-photo-259707.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//       "url": "https://assets.mixkit.co/music/preview/mixkit-delightful-4.mp3",
//     },
//     {
//       "title": "Life is a Dream",
//       "artist": "Michael Ramir",
//       "cover":
//           "https://images.pexels.com/photos/1884306/pexels-photo-1884306.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//       "url":
//           "https://assets.mixkit.co/music/preview/mixkit-life-is-a-dream-837.mp3",
//     },
//     {
//       "title": "Feeling Happy",
//       "artist": "Ahjay Stelino",
//       "cover":
//           "https://images.pexels.com/photos/2682877/pexels-photo-2682877.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//       "url":
//           "https://assets.mixkit.co/music/preview/mixkit-feeling-happy-5.mp3",
//     },
//     {
//       "title": "Dance with Me",
//       "artist": "Ahjay Stelino",
//       "cover":
//           "https://images.pexels.com/photos/235615/pexels-photo-235615.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//       "url":
//           "https://assets.mixkit.co/music/preview/mixkit-dance-with-me-3.mp3",
//     },
//     {
//       "title": "Sleepy Cat",
//       "artist": "Alejandro Magaña",
//       "cover":
//           "https://images.pexels.com/photos/1122868/pexels-photo-1122868.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//       "url": "https://assets.mixkit.co/music/preview/mixkit-sleepy-cat-135.mp3",
//     },
//     {
//       "title": "Delightful",
//       "artist": "Ahjay Stelino",
//       "cover":
//           "https://images.pexels.com/photos/259707/pexels-photo-259707.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//       "url": "https://assets.mixkit.co/music/preview/mixkit-delightful-4.mp3",
//     },
//   ];

//   String currentTitle = "";
//   String currentArtist = "";
//   String currentCover = "";
//   String currentSong = "";
//   IconData btnIcon = Icons.play_arrow;

//   AudioPlayer _audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
//   bool isPlaying = false;
//   Duration musicDuration = Duration();
//   Duration musicPosition = Duration();

//   playMusic(String url) async {
//     if (isPlaying && currentSong != url) {
//       _audioPlayer.pause();
//       int result = await _audioPlayer.play(url);
//       if (result == 1) {
//         setState(() {
//           currentSong = url;
//         });
//       }
//     } else if (!isPlaying) {
//       int result = await _audioPlayer.play(url);
//       if (result == 1) {
//         setState(() {
//           isPlaying = true;
//           btnIcon = Icons.pause;
//         });
//       }
//     }

//     _audioPlayer.onDurationChanged.listen((event) {
//       setState(() {
//         musicDuration = event;
//       });
//     });

//     _audioPlayer.onAudioPositionChanged.listen((event) {
//       setState(() {
//         musicPosition = event;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xff3C415C),
//               Color(0xff232323),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.only(
//                   left: 22.0,
//                   right: 22.0,
//                   top: 15.0,
//                   bottom: 15.0,
//                 ),
//                 alignment: Alignment.topLeft,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Music play",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 22.0,
//                       ),
//                     ),
//                     CircleAvatar(
//                       backgroundImage: AssetImage("images/sk.jpg"),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: musicList.length,
//                     itemBuilder: (context, index) => InkWell(
//                       onTap: () {
//                         playMusic(musicList[index]["url"]);
//                         setState(() {
//                           currentTitle = musicList[index]["title"];
//                           currentArtist = musicList[index]["artist"];
//                           currentCover = musicList[index]["cover"];
//                         });
//                       },
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           backgroundImage: NetworkImage(
//                             musicList[index]["cover"],
//                           ),
//                         ),
//                         title: Text(
//                           musicList[index]["title"],
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                         subtitle: Text(
//                           musicList[index]["artist"],
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w200,
//                           ),
//                         ),
//                         trailing: Container(
//                           margin: EdgeInsets.all(17.0),
//                           child: Icon(
//                             Icons.music_note,
//                             color: Colors.blueGrey.shade200,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 child: Column(
//                   children: [
//                     Container(
//                       color: Colors.white,
//                       height: 1.0,
//                     ),
//                     ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: NetworkImage(currentCover),
//                       ),
//                       title: Text(
//                         currentTitle,
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                       subtitle: Text(
//                         currentArtist,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w200,
//                         ),
//                       ),
//                       trailing: Container(
//                         height: 40.0,
//                         width: 40.0,
//                         margin: EdgeInsets.all(7.0),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Colors.grey,
//                           ),
//                         ),
//                         child: IconButton(
//                           padding: EdgeInsets.zero,
//                           onPressed: () {
//                             if (isPlaying) {
//                               _audioPlayer.pause();
//                               setState(() {
//                                 btnIcon = Icons.play_arrow;
//                                 isPlaying = false;
//                               });
//                             } else {
//                               _audioPlayer.resume();

//                               setState(() {
//                                 btnIcon = Icons.pause;
//                                 isPlaying = true;
//                               });
//                             }
//                           },
//                           icon: Icon(
//                             btnIcon,
//                             size: 26,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         left: 22.0,
//                         right: 30.0,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Text(
//                             "${musicPosition.inMinutes}:${musicPosition.inSeconds.remainder(60)}",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w200,
//                             ),
//                           ),
//                           Expanded(
//                             child: Slider.adaptive(
//                               activeColor: Colors.white,
//                               inactiveColor: Colors.grey,
//                               value: musicPosition.inSeconds.toDouble(),
//                               max: musicDuration.inSeconds.toDouble(),
//                               onChanged: (val) {},
//                             ),
//                           ),
//                           Text(
//                             "${musicDuration.inMinutes}:${musicDuration.inSeconds.remainder(60)}",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w200,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
