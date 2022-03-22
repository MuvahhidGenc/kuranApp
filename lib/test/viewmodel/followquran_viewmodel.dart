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
import 'package:kuran/test/model/sure_name_model.dart';
import 'package:kuran/test/widgets/bottomsheetfontsize_widget.dart';
import 'package:kuran/test/widgets/bottomsheetmeal_widget.dart';
import 'package:path_provider/path_provider.dart';

class FollowQuranViewModel extends ChangeNotifier {
  var _arabicNumber = ArabicNumbers();
  var _arabicNumberConvert;
  // AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
//  PlayerState? audioPlayerState;
  // int aktifsurah = 0;
  List<Ayah>? getAyahList;
  IconData? floattingActionButtonIcon;
  PageController pageController =
      PageController(initialPage: 0, keepPage: false);
  List<Ayah> getTexts = [];
  bool _bottomSheetTextFontState = false;
  bool _bottomSheetMealState = false;
  double _fontSize = 20;
  List<Datum>? surahNames;

  /*audioPlayerStream() {
   audioPlayer.onDurationChanged.listen((event) {
     print(event.inSeconds.toDouble());
   });
    audioPlayer.onPlayerStateChanged.listen((state) async {
      audioPlayerState = state;
      var totalAyah = getAyahList!.length;
      print(aktifsurah);
      if (audioPlayerState == PlayerState.COMPLETED && aktifsurah < totalAyah) {
        await audioPlayer.stop();
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
     await audioPlayer.play(path,isLocal: false);
    }
    // notifyListeners();
  }

  Future onlyPlayAudio({required String path}) async {
   await audioPlayer.play(path,isLocal: false);
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
        
  }*/

  get textFontState => _bottomSheetTextFontState;
  get fontSize => _fontSize;
  get bottomSheetMealState => _bottomSheetMealState;
  get bottomSheetController {
    if (textFontState) {
      return BottomSheetFontSizeWidget();
    } else if (bottomSheetMealState) {
      return BottomSheetMealWidget();
    }
    return SizedBox(
      height: 0,
    );
  }

  void gotoPage(PageController pageController, int page) {
    pageController.animateToPage(page.toInt(),
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
    notifyListeners();
  }

  void nextPage(PageController pageController) {
    pageController.animateToPage(pageController.page!.toInt() + 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  setBottomSheetMealState(bool mealState) {
    _bottomSheetMealState = mealState;
    notifyListeners();
  }

  setTextFontState(bool textFontState) {
    _bottomSheetTextFontState = textFontState;
    notifyListeners();
  }

  setTextFontSize(double fontsize) {
    _fontSize = fontsize;
    notifyListeners();
  }

  modelSheetMenuSelectedItem(String selectedItem) {
    if (returnSelectedItemName(ModelSheetMenuItems.gotoSurah, selectedItem)) {
      print("Süreye Git OnClick is Working");
    }
    if (returnSelectedItemName(ModelSheetMenuItems.gotojuz, selectedItem)) {
      print("Cüze Git OnClick is Working");
    }
    if (returnSelectedItemName(ModelSheetMenuItems.gotopage, selectedItem)) {
      print("Sayfaya Git OnClick is Working");
    }
  }

  returnSelectedItemName(ModelSheetMenuItems name, String selectedItem) {
    if (ModelSheetMenuExtension(name).modelSheetMenuItemString == selectedItem)
      return true;
    else
      return false;
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
    if (zipPath == ExcationManagerEnum.downloadEroor) {
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
  getSureNameslist() async {
    //get List Surah Names;
    var getSureNames = await rootBundle.loadString("assets/jsons/surahs.json");
    surahNames = SureNameModel.fromJson(jsonDecode(getSureNames)).data;

    notifyListeners();
    
    }

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
