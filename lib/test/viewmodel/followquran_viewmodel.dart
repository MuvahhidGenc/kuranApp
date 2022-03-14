import 'dart:convert';
import 'dart:io';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/globals/manager/network_manager.dart';
import 'package:kuran/test/model/followquran_model.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path_provider/path_provider.dart';

class FollowQuranViewModel extends ChangeNotifier {
  var _arabicNumber = ArabicNumbers();
  var _arabicNumberConvert;
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  PlayerState? audioPlayerState;
  int aktifsurah = 0;
  List<Ayah>? getAyahList;
  IconData? floattingActionButtonIcon;
  PageController pageController =
      PageController(initialPage: 0, keepPage: false);
  List<Ayah> getTexts = [];

  audioPlayerStream() {
   audioPlayer.onPlayerError.listen((msg) {
     print(msg);
   });
    audioPlayer.onPlayerStateChanged.listen((state) async {
      audioPlayerState = state;
      var totalAyah = getAyahList!.length;

        

      if (audioPlayerState == PlayerState.COMPLETED && aktifsurah < totalAyah) {
        aktifsurah++;

        await playAudio(path: getAyahList![aktifsurah - 1].audioSecondary![1]);
        print(aktifsurah.toString() + " - " + totalAyah.toString());
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
    
      await audioPlayer.stop();
    } else {
     await audioPlayer.play(path,isLocal: true);
    }
    // notifyListeners();
  }

  Future onlyPlayAudio({required String path}) async {
   await audioPlayer.play(path,isLocal: true);
    // notifyListeners();
  }

  stopAudio() async{
   await audioPlayer.stop();
    notifyListeners();
  }

  void nextPage(PageController pageController) {
    pageController.animateToPage(pageController.page!.toInt() + 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  onChangePage(int page)async{
        getAyahList =await quranGetText(page+1);
        print(getAyahList![0].text);
        aktifsurah = 1;
        await stopAudio();
        
  }



  Future quranGetText(int page) async {
    getTexts = await getText(pageNo: page, kariId: "ar.alafasy");
    //notifyListeners();
    return getTexts;
  }

  Future downloadAudioZip(String fileName) async {
    var file = await NetworkManager().downloadFile(
      url: UrlsConstant.KURAN_MP3_TRAR_URL + "versebyverse/$fileName.zip",
      fileName: fileName,
    );
    zipExtract(file, fileName);
  }

  Future zipExtract(String zipPath, String fileName) async {
    
    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}";

    final zipFile = File(zipPath);
    final appDataDir = Directory.systemTemp;
    final destinationDir = Directory("${appDataDir.path}");
    if(zipPath== ExcationManagerEnum.downloadEroor){
      print("download Error");
      destinationDir.delete(recursive: true);
      
      return;
    }
    if (destinationDir.existsSync()) {
      return;
    }
    try {
      await ZipFile.extractToDirectory(
          zipFile: zipFile,
          destinationDir: destinationDir,
          onExtracting: (zipEntry, progress) {
            print('progress: ${progress.toStringAsFixed(1)}%');
            print('name: ${zipEntry.name}');
            print('isDirectory: ${zipEntry.isDirectory}');
            print(
                'modificationDate: ${zipEntry.modificationDate!.toLocal().toIso8601String()}');
            print('uncompressedSize: ${zipEntry.uncompressedSize}');
            print('compressedSize: ${zipEntry.compressedSize}');
            print('compressionMethod: ${zipEntry.compressionMethod}');
            print('crc: ${zipEntry.crc}');
            return ZipFileOperation.includeItem;
          });
    } catch (e) {
      print(e);
    }
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
    notifyListeners();
    return getPagevar.ayahs;
  }



  convertToArabicNumber(int number) {
    return _arabicNumber.convert(number).toString();
  }
}
