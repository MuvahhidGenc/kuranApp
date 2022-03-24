import 'package:audioplayers/audioplayers.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/globals/widgets/alertdialog_widget.dart';
import 'package:kuran/globals/widgets/cupertionpicker_widget.dart';
import 'package:kuran/test/model/followquran_model.dart';
import 'package:kuran/test/model/sure_name_model.dart';
import 'package:kuran/test/viewmodel/followquran_viewmodel.dart';
import 'package:kuran/view/kuran/model/sure_name_model.dart';
import 'package:provider/provider.dart';

class FollowQuranView extends StatefulWidget {
  const FollowQuranView({Key? key}) : super(key: key);

  @override
  _FollowQuranViewState createState() => _FollowQuranViewState();
}

class _FollowQuranViewState extends State<FollowQuranView> {
  var _followQuranViewModel = FollowQuranViewModel();
  List<Ayah> getText = [];
  bool fullScreen = false;
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  PlayerState? audioPlayerState;
  //int _followQuranViewModel.aktifsurah = 0;

  @override
  void initState() {
    // TODO: implement initState
    fullScreen = false;
    super.initState();
    quranGetText(1);
    _followQuranViewModel =
        Provider.of<FollowQuranViewModel>(context, listen: false);
    _followQuranViewModel.getSureNameslist();
    //_followQuranViewModel._followQuranViewModel.aktifsurah = 0;
    audioPlayerStream();

    //addKeysGlobalKey();
  }

  Future playAudio({required String path, bool? onlyPlay}) async {
    if (audioPlayerState == PlayerState.PLAYING) {
      await audioPlayer.stop();
    } else {
      await audioPlayer.play(path, isLocal: false);
    }
    // notifyListeners();
  }

  Future onlyPlayAudio({required String path}) async {
    await audioPlayer.play(path, isLocal: false);
    // notifyListeners();
  }

  stopAudio() async {
    await audioPlayer.stop();
  }

  audioPlayerStream() {
    audioPlayer.onPlayerStateChanged.listen((state) async {
      audioPlayerState = state;
      var totalAyah = getText.length;
      if (audioPlayerState == PlayerState.COMPLETED &&
          _followQuranViewModel.aktifsurah < totalAyah) {
        // await audioPlayer.stop();
        _followQuranViewModel.aktifsurah++;
        // _followQuranViewModel._followQuranViewModel.aktifsurah = _followQuranViewModel.aktifsurah;
        if(_followQuranViewModel.bottomSheetMealState==true){
         await _followQuranViewModel.getTranslation();
        }
        
        await playAudio(
            path: getText[_followQuranViewModel.aktifsurah - 1]
                .audioSecondary![1]);
        //print(_followQuranViewModel.aktifsurah.toString() + " - " + totalAyah.toString());
        _followQuranViewModel.floattingActionButtonIcon =
            Icons.play_circle_fill;
      } else if (audioPlayerState == PlayerState.COMPLETED &&
          _followQuranViewModel.aktifsurah == totalAyah) {
       // _followQuranViewModel.aktifsurah = -1;
        _followQuranViewModel.floattingActionButtonIcon =
            Icons.play_circle_fill;
        await _followQuranViewModel
            .nextPage(_followQuranViewModel.pageController);
        _followQuranViewModel.aktifsurah = 0;
        //  _followQuranViewModel._followQuranViewModel.aktifsurah = _followQuranViewModel.aktifsurah;
      }
      if (audioPlayerState == PlayerState.PLAYING) {
        _followQuranViewModel.floattingActionButtonIcon =
            Icons.pause_circle_filled;
      } else if (audioPlayerState == PlayerState.STOPPED ||
          audioPlayerState == PlayerState.PAUSED ||
          _followQuranViewModel.floattingActionButtonIcon == null) {
        _followQuranViewModel.floattingActionButtonIcon =
            Icons.play_circle_fill;
      }
      // print(_followQuranViewModel.aktifsurah);

      setState(() {});
    });
  }

  Future quranGetText(int page) async {
    getText = await Provider.of<FollowQuranViewModel>(context, listen: false)
        .quranGetText(page);

    /*print(await GetPageAPI()
        .getFileSize(UrlsConstant.KURAN_MP3_TRAR_URL + "versebyverse/3.zip"));*/
    return getText;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //audioPlayer.dispose();
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //WidgetsBinding.instance?.addPostFrameCallback((_) => _scrollToBottom());
    var theme = SnippetExtanstion(context).theme;
    var provider = Provider.of<FollowQuranViewModel>(context);

    return Scaffold(
      backgroundColor: theme.listTileTheme.iconColor,
      appBar: !fullScreen ? appBar() : null,
      body: bodyPageView(provider, theme, context),
      floatingActionButton: fullScreen
          ? floatingActionBottom(provider)
          : null /*provider.textFontState?textFontSizeSettingWidget(provider)*/ /*:null*/,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      bottomNavigationBar: !fullScreen ? bottomNavigatorBar(provider) : null,
      bottomSheet: provider.bottomSheetController,
    );
  }

  ConvexAppBar bottomNavigatorBar(FollowQuranViewModel provider) =>
      ConvexAppBar(
        style: TabStyle.fixedCircle,
        backgroundColor: SnippetExtanstion(context).theme.primaryColor,
        items: [
          const TabItem(icon: Icons.list, title: ""),
          const TabItem(
              icon: Icons.speaker_notes_off,
              activeIcon: Icons.speaker_notes,
              title: ""),
          TabItem(
              icon:
                  provider.floattingActionButtonIcon ?? Icons.play_circle_fill,
              title: "",
              isIconBlend: true),
          const TabItem(icon: Icons.text_fields, title: ""),
          const TabItem(icon: Icons.fullscreen, title: ""),
        ],
        initialActiveIndex: 2,
        onTap: (int i) async{
          if (i == 1) {
            
           await _followQuranViewModel.getTranslation();
            provider.setBottomSheetMealState(!provider.bottomSheetMealState);
            
          } else if (i == 2) {
            provider.getAyahList = getText;
            var path = getText[0].audioSecondary![1];

            _followQuranViewModel.aktifsurah = 1;
            playAudio(path: path);

            // print(audioPlayerState);

          } else if (i == 4) {
            fullScreen = !fullScreen;
            setState(() {});
          } else if (i == 3) {
            provider.setTextFontState(!provider.textFontState);
          } else if (i == 0) {
            _onPressChoisePageBottomSheetModel(provider);
          }
          if (i != 3) {
            provider.setTextFontState(false);
          }
          if (i != 1) {
            provider.setBottomSheetMealState(false);
          }
        },
      );

  FloatingActionButton floatingActionBottom(FollowQuranViewModel provider) {
    return FloatingActionButton(
      child: const Icon(
        Icons.fullscreen_exit,
      ),
      mini: true,
      onPressed: () {
        fullScreen = !fullScreen;
        setState(() {});
      },
    );
  }

  PageView bodyPageView(
      FollowQuranViewModel provider, ThemeData theme, BuildContext context) {
    return PageView.builder(
      controller: provider.pageController,
      itemCount: 604,
      onPageChanged: (int page) async {
        getText = await quranGetText(page + 1);
        provider.getAyahList = getText;
        _followQuranViewModel.aktifsurah = 1;
        _followQuranViewModel.getTranslation();
        await audioPlayer.stop();
        var path = getText[0].audioSecondary![1];
        onlyPlayAudio(path: path);
      },
      itemBuilder: (context, index) {
        // ignore: avoid_unnecessary_containers
        //provider.downloadAudioZip((index + 2).toString());
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: theme.primaryColor)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: quranPageListText(provider, context),
            ),
          ),
        );
      },
    );
  }

  AppBar appBar() {
    return AppBar(
        title: Column(
      children: [
        Center(
          child: Text(
           _followQuranViewModel.aktifSurahName=="" ? getText.isEmpty ? "" : getText[0].surah!.englishName!:_followQuranViewModel.aktifSurahName,
            textAlign: TextAlign.left,
          ),
        ),
        Wrap(
          spacing: 2.0,
          children: [
            Text(
             getText.isEmpty
                  ? ""
                  : " Sayfa : {${getText[0].page.toString()} / 604} - ",
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 15),
            ),
            Text(
              getText.isEmpty
                  ? ""
                  : " Cüz : {${getText[0].juz.toString()} / 30}",
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        )
      ],
    ));
  }

  Widget quranPageListText(
      FollowQuranViewModel _fqvmProvider, BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        RichText(
          overflow: TextOverflow.clip,
          //textScaleFactor: 1.1,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          text: TextSpan(
            style: TextStyle(
                fontSize: _fqvmProvider.fontSize,
                color: SnippetExtanstion(context).theme.primaryColorLight),
            children: getText.map((e) {
              var listNumber = getText.indexOf(e);
              return TextSpan(
                style: listNumber == _followQuranViewModel.aktifsurah - 1
                    ? const TextStyle(
                        backgroundColor: Colors.grey,
                        fontFamily: 'KFGQPC Uthman Taha Naskh',
                      )
                    : const TextStyle(
                        fontFamily: 'KFGQPC Uthman Taha Naskh',
                      ),
                text: " " + e.text!.trim() + " ",
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    _fqvmProvider.getAyahList = getText;
                    _followQuranViewModel.aktifsurah = listNumber + 1;
                    _followQuranViewModel.getTranslation();
                    onlyPlayAudio(path: e.audioSecondary![1]);
                  },
                children: [
                  WidgetSpan(
                      child: CircleAvatar(
                    radius: 10,
                    child: Text(_followQuranViewModel
                        .convertToArabicNumber(e.numberInSurah!)),
                  )),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  _onPressChoisePageBottomSheetModel(FollowQuranViewModel provider) async {
    print(provider.surahNames!.length);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          var gotoSurah = ModelSheetMenuExtension(ModelSheetMenuItems.gotoSurah)
              .modelSheetMenuItemString!;
          var gotoJuz = ModelSheetMenuExtension(ModelSheetMenuItems.gotojuz)
              .modelSheetMenuItemString!;
          var gotoPage = ModelSheetMenuExtension(ModelSheetMenuItems.gotopage)
              .modelSheetMenuItemString!;
          return Container(
            height: SnippetExtanstion(context).media.size.height * 0.3,
            child: Column(
              children: [
                bottomSheetMenuListTile(provider, gotoSurah, onClick: () {
                  gotoModelPicker(
                    gotoSurah,
                    List.generate(
                      provider.surahNames!.length,
                      (i) => Text((i + 1).toString() +
                          "." +
                          provider.surahNames![i].name! +
                          " Süresi"),
                    ),
                  );
                  // +"."+provider.surahNames![i].name!
                }),
                bottomSheetMenuListTile(provider, gotoJuz, onClick: () {
                  gotoModelPicker(
                    gotoJuz,
                    List.generate(
                      30,
                      (i) => Text((i + 1).toString()),
                    ),
                  );
                }),
                bottomSheetMenuListTile(
                  provider,
                  gotoPage,
                  onClick: () => gotoModelPicker(
                      gotoPage,
                      List.generate(
                          604, (index) => Text((index + 1).toString()))),
                ),
              ],
            ),
          );
        });
  }

  ListTile bottomSheetMenuListTile(FollowQuranViewModel provider, String name,
      {Icon? leftIcon, Icon? rightIcon, required VoidCallback onClick}) {
    return ListTile(
      leading: leftIcon ?? Icon(Icons.list_alt),
      title: Text(name),
      onTap: onClick,
      trailing: rightIcon ?? Icon(Icons.arrow_right),
    );
  }

  void gotoModelPicker(String buttonName, List<Widget> children) {
    Navigator.pop(context);
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return cupertinoPicker(children, buttonName);
        });
  }

  Container cupertinoPicker(List<Widget> children, String buttonName) {
    int page = 0;
    return Container(
      color: SnippetExtanstion(context).theme.scaffoldBackgroundColor,
      height: MediaQuery.of(context).copyWith().size.height * 0.4,
      child: Column(
        children: [
          Expanded(
            child: CupertinoPicker(
              children: children,
              onSelectedItemChanged: (value) {
                if (buttonName ==
                    ModelSheetMenuExtension(ModelSheetMenuItems.gotojuz)
                        .modelSheetMenuItemString)
                  page = (value * 20) + 1;
                else if (buttonName ==
                    ModelSheetMenuExtension(ModelSheetMenuItems.gotoSurah)
                        .modelSheetMenuItemString)
                  page = _followQuranViewModel.surahNames![value].pageNumber!;
                else if (buttonName ==
                    ModelSheetMenuExtension(ModelSheetMenuItems.gotopage)
                        .modelSheetMenuItemString) {
                  page = value;
                }
              },
              itemExtent: 25,
              diameterRatio: 1,
              useMagnifier: true,
              magnification: 1.3,
              looping: true,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _followQuranViewModel.gotoPage(
                      _followQuranViewModel.pageController, page);
                },
                child: Text(buttonName),
                // icon: Icon(Icons.arrow_right),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
