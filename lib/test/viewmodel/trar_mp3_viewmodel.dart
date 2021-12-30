import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/globals/manager/filepath_manager.dart';
import 'package:kuran/globals/manager/network_manager.dart';
import 'package:kuran/test/widgets/trar_list_builder_widget.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class TrArMp3ViewModel extends ChangeNotifier {
  var sureNameModel = SureNameModel();
  String sureListName = "surelist.json";
  Map<int, bool> playController = Map<int, bool>();
  Map<int, dynamic> audioPathController = Map<int, bool>();
  Map<int, Widget> downloadControlWidget = Map<int, Widget>();
  Map<int, Widget> playingWidget = Map();
  Map<int, bool> dowloading = Map();

  late AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  PlayerState? audioPlayerState;
  Duration duration = Duration();
  Duration position = Duration();
  double progress = 0;
  int? activeSurah;
  String? activeSurahName;

  IconData? buttomSheetPlayIcon;

  audioPlayerStream() {
    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      duration = d;
      notifyListeners();
    });

    var posControl = false;
    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      print('Max duration: ${p.inMinutes}:${p.inSeconds}' +
          " Duration : ${duration.inMinutes}: ${duration.inSeconds}");
      position = p;
      notifyListeners();
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      audioPlayerState = state;
      notifyListeners();
    });
  }

  Future playAudip({required String path, required int index}) async {
    if (playController[index] == true) {
      audioPlayer.play(path);
      buttomSheetPlayIcon = Icons.pause_circle;
    } else if (audioPlayerState == PlayerState.PLAYING) {
      audioPlayer.pause();
      buttomSheetPlayIcon = Icons.play_circle;
    } else if (audioPlayerState == PlayerState.PAUSED) {
      audioPlayer.resume();
      buttomSheetPlayIcon = Icons.play_circle;
    }
    notifyListeners();
  }

  bottomSheetPlayButtonClick() async {
    if (activeSurah != null) {
      var path =
          await FilePathManager().converToPath("trar_${activeSurah! + 1}.mp3");
      if (audioPlayerState == PlayerState.PLAYING) {
        audioPlayer.pause();
        buttomSheetPlayIcon = Icons.play_circle_fill;
        playController[activeSurah!] = true;
      } else if (audioPlayerState == PlayerState.PAUSED) {
        audioPlayer.resume();
        buttomSheetPlayIcon = Icons.pause_circle_filled;
        playController[activeSurah!] = true;
      } else if (audioPathController[activeSurah] != false) {
        playController[activeSurah!] = true;
        audioPlayer.play(path);
      }
    }
    notifyListeners();
  }

  bottomSheetNextAndBack({required String work}) async {
    print("Work İçerisinde");
    if (activeSurah != null) {
      playController[activeSurah!] = false;
      if (work == "next" && activeSurah! < 113) activeSurah = activeSurah! + 1;
      if (work == "previouse" && activeSurah! > 0)
        activeSurah = activeSurah! - 1;

      var path =
          await FilePathManager().converToPath("trar_${activeSurah! + 1}.mp3");
      playController[activeSurah!] = true;
      audioPlayer.play(path);
    }
    notifyListeners();
  }

  Future downloadFile({required String url, required String fileName}) async {
    Dio dio = Dio();
    var dir = await getApplicationDocumentsDirectory();
    var path = "${dir.path}/$fileName";
    var pathState = File(path);
    if (!pathState.existsSync()) {
      await dio.download(url, path, onReceiveProgress: (rec, total) {
        progress = ((rec / total));
        notifyListeners();
      });
    }

    return path;
  }

  Future<SureNameModel> getSureNameModel() async {
    //get List Surah Names;
    var getSureName = await NetworkManager().saveStorage(
        url: UrlsConstant.ACIK_KURAN_URL + "/surahs",
        folder: DirectoryNameEnum(DirectoryName.surenamelist).getjsonPath,
        fileName: sureListName);

    sureNameModel = SureNameModel.fromJson(jsonDecode(getSureName));

    return sureNameModel;
  }

  get getSureListWidget async {
    return TrArListBuilderWidget(
      await getSureNameModel(),
    );
  }

  getPlayController({int? index}) async {
    if (index != null) {
      activeSurah = index;
      if (playController[index] == true) {
        playController[index] = false;
      } else if (playController[index] != true) {
        playController = await createMap(playController, false);
        playController[index] = true;
      }
    }
    audioPlayer.stop();
    notifyListeners();
  }

  Future<String> pathControllerAndDownload(String url, String fileName) async {
    return await downloadFile(url: url, fileName: fileName);
  }

  Future pathController(String path) async =>
      await FilePathManager().getFilePathControl(path);

  get createAudioPathControl async {
    sureNameModel = await getSureNameModel();
    for (var i = 0; i <= sureNameModel.data!.length; i++) {
      audioPathController[i] = await pathController("trar_${i + 1}.mp3");
      if (audioPathController[i] == false) {
        downloadControlWidget[i] = Icon(Icons.download);
      }
    }
    notifyListeners();
  }

  Future downloadingAudio(int i) async {
    dowloading[i] = true;
    notifyListeners();
    String path = await pathControllerAndDownload(
        UrlsConstant.KURAN_MP3_TRAR_URL + "artukmp3/${i + 1}.mp3",
        "trar_${i + 1}.mp3");
    audioPathController[i] = await pathController("trar_${i + 1}.mp3");
    if (audioPathController[i] == false) {
      downloadControlWidget[i] = Icon(Icons.download);
      playController[i] = false;
      dowloading[i] = false;
    }
    notifyListeners();
    return path;
  }

  //get getPathControlList async => await createAudioPathControl;

  Future createMap(Map<int, dynamic> map, dynamic value) async {
    sureNameModel = await getSureNameModel();
    for (var i = 0; i <= sureNameModel.data!.length; i++) {
      map[i] = value;
    }
    return map;
  }

// ontap ListTile Click Event;

  Future<void> onClickListTile(int index) async {
    String path = await downloadingAudio(index);
    await getPlayController(index: index);
    playAudip(path: path, index: index);
    print(audioPlayerState);
  }

  // İcon Controller Widget

  Widget IconController(TrArMp3ViewModel provider, int index) {
    Widget icon = Text("");
    if (provider.audioPathController[index] == true) {
      if (provider.playController[index] != true) {
        icon = const Icon(Icons.play_circle);
      } else {
        icon = const Icon(Icons.pause_circle);
      }
    } else if (provider.audioPathController[index] != true) {
      if (provider.dowloading[index] == true) {
        icon = CircularProgressIndicator(
          value: provider.progress,
        );
      } else if (provider.downloadControlWidget[index] != null) {
        icon = provider.downloadControlWidget[index] as Widget;
      }
    }

    return icon;
  }
}
