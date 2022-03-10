import 'dart:convert';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/globals/extantions/urlpath_extanstion.dart';
import 'package:kuran/test/model/followquran_model.dart';

class FollowQuranViewModel extends ChangeNotifier {
  var _arabicNumber = ArabicNumbers();
  var _arabicNumberConvert;
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  PlayerState? audioPlayerState;
  int aktifsurah = 0;
  List<Ayah>? getAyahList;
  IconData? floattingActionButtonIcon;
  PageController pageController = PageController();



  audioPlayerStream() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      // print("test");
      audioPlayerState = state;
      var totalAyah = getAyahList!.length;
     

      if (audioPlayerState == PlayerState.COMPLETED && aktifsurah < totalAyah) {
        aktifsurah++;
        playAudio(path: getAyahList![aktifsurah - 1].audioSecondary![1]);
        floattingActionButtonIcon = Icons.play_circle_fill;
      } else if (audioPlayerState == PlayerState.COMPLETED &&
          aktifsurah == totalAyah) {
        aktifsurah = -1;
        floattingActionButtonIcon = Icons.play_circle_fill;
        // nextPage(pageController);
        // aktifsurah=1;
      }
      if (audioPlayerState == PlayerState.PLAYING) {
        floattingActionButtonIcon = Icons.pause_circle_filled;
      } else if (audioPlayerState == PlayerState.STOPPED ||
          audioPlayerState == PlayerState.PAUSED ||
          floattingActionButtonIcon == null) {
        floattingActionButtonIcon = Icons.play_circle_fill;
      }
      // print(aktifsurah);
      notifyListeners();
    });
  }

  Future playAudio({required String path}) async {
    if (audioPlayerState == PlayerState.PLAYING) {
      audioPlayer.pause();
    } else {
      audioPlayer.play(path);
    }
    notifyListeners();
  }
  stopAudio() {
   audioPlayer.stop();
  }

  void nextPage(PageController pageController) {
    pageController.animateToPage(pageController.page!.toInt() + 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }
   List<Ayah> getTexts = [];

  Future quranGetText(int page) async {
    getTexts =
        await getText(pageNo: page, kariId: "ar.alafasy");

    return getTexts;
  }

/*Future quranGetText(int page) async {
    getText =
        await _followQuranViewModel.getText(pageNo: page, kariId: "ar.alafasy");
    return getText;
  }*/
  /*getPage({required int pageNo, required String kariId}) async {
    final response = await http.get(Uri.parse(UrlsConstant.ALQURANCLOUDV1 +
        UrlPathExtanstion(URLAlQuranPath.page).urlPath! +
        "$pageNo/$kariId"));
    if (response.statusCode == 200) {
      Map<String, dynamic> decode = jsonDecode(response.body);
      var get = FollowQuranModel.fromJson(decode);
      return get.data;
    }
  }

  getText({required int pageNo, String? kariId}) async {
    var getPagevar = await getPage(pageNo: pageNo, kariId: kariId!);
    return getPagevar.ayahs;
  }*/
 getPage({required int pageNo, required String kariId}) async {
    final data = await rootBundle.loadString('assets/quranpage/$pageNo.json');
  Map<String, dynamic> decode = jsonDecode(data);
  var get = FollowQuranModel.fromJson(decode);
  
  return get.data;
  }

  getText({required int pageNo, String? kariId}) async {
    var getPagevar = await getPage(pageNo: pageNo, kariId: kariId!);
    return getPagevar.ayahs;
  }
  getAudio() async {}

  convertToArabicNumber(int number) {
    return _arabicNumber.convert(number).toString();
  }
}
