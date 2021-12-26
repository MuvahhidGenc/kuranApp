import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/globals/manager/network_manager.dart';
import 'package:kuran/test/widgets/trar_list_builder_widget.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';

class TrArMp3ViewModel {
  var sureNameModel = SureNameModel();
  String sureListName = "surelist.json";
  Map<int, bool> playController = Map<int, bool>();
  Map<int, bool> audioPathController = Map<int, bool>();

  late AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  late PlayerState AudioPlayerState = PlayerState.STOPPED;

  Future<SureNameModel> getSureNameModel() async {
    //get List Surah Names;
    var getSureName = await NetworkManager().saveStorage(
        url: UrlsConstant.ACIK_KURAN_URL + "/surahs",
        folder: DirectoryNameEnum(DirectoryName.surenamelist).getjsonPath,
        fileName: sureListName);

    sureNameModel = SureNameModel.fromJson(jsonDecode(getSureName));

    return sureNameModel;
  }

  Future<Map<int, bool>> getPlayController({int? index}) async {
    await createPlayerController;
    if (index != null && playController[index] == true) {
      playController[index] = false;
    } else if (index != null) {
      playController[index] = true;
    }
    return playController;
  }

  Future<String> pathControllerAndDownload(String url, String fileName) async {
    return await NetworkManager()
        .downloadMediaFile(url: url, folderandpath: fileName);
  }

  audioPlay(String path) {
    return audioPlayer.play(path);
  }

  get getSureListWidget async {
    return TrArListBuilderWidget(
        await getSureNameModel(), await getPlayController());
  }

  get createPlayerController async {
    sureNameModel = await getSureNameModel();
    for (var i = 0; i <= sureNameModel.data!.length; i++) {
      playController[i] = false;
    }
  }
}
