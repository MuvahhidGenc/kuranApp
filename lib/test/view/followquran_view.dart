import 'package:audioplayers/audioplayers.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/test/model/followquran_model.dart';
import 'package:kuran/test/viewmodel/followquran_viewmodel.dart';
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
  int aktifsurah = 0;
  List<GlobalKey> keys = List.empty();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    fullScreen = false;
    super.initState();
    quranGetText(1);
    _followQuranViewModel =
        Provider.of<FollowQuranViewModel>(context, listen: false);
    audioPlayerStream();
    //addKeysGlobalKey();
  }

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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

  void nextPage(PageController pageController) {
    pageController.animateToPage(pageController.page!.toInt() + 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  audioPlayerStream() {
    addKeysGlobalKey() {
      keys = List.generate(getText.length, (i) => GlobalKey());
    }

    audioPlayer.onPlayerStateChanged.listen((state) async {
      audioPlayerState = state;
      var totalAyah = getText.length;
      if (audioPlayerState == PlayerState.COMPLETED && aktifsurah < totalAyah) {
        // await audioPlayer.stop();
        aktifsurah++;
        /*Scrollable.ensureVisible(
   keys[aktifsurah-1].currentContext!,
   alignment: 0.2,
   duration: Duration(milliseconds: 500),
);*/
        await playAudio(path: getText[aktifsurah - 1].audioSecondary![1]);
        //print(aktifsurah.toString() + " - " + totalAyah.toString());
        _followQuranViewModel.floattingActionButtonIcon =
            Icons.play_circle_fill;
      } else if (audioPlayerState == PlayerState.COMPLETED &&
          aktifsurah == totalAyah) {
        aktifsurah = -1;
        _followQuranViewModel.floattingActionButtonIcon =
            Icons.play_circle_fill;
        nextPage(_followQuranViewModel.pageController);
        aktifsurah = 1;
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
      // print(aktifsurah);

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
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => _scrollToBottom());
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
      bottomSheet:
          provider.textFontState ? textFontSizeSettingWidget(provider) : null,
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
        onTap: (int i) {
          if (i == 2) {
            provider.setTextFontState(false);
            provider.getAyahList = getText;
            var path = getText[0].audioSecondary![1];

            aktifsurah = 1;
            playAudio(path: path);

            // print(audioPlayerState);

          } else if (i == 4) {
            provider.setTextFontState(false);
            fullScreen = !fullScreen;
            setState(() {});
          } else if (i == 3) {
            provider.setTextFontState(!provider.textFontState);
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

  Widget textFontSizeSettingWidget(FollowQuranViewModel provider) {
    return Container(
      height: 75,
      child: Slider.adaptive(
        min: 17,
        value: provider.fontSize,
        max: 40,
        onChanged: (double value) => provider.setTextFontSize(value),
      ),
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
        aktifsurah = 1;
        await audioPlayer.stop();
        var path = getText[0].audioSecondary![1];
        playAudio(path: path);
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
            getText.isEmpty ? "" : getText[0].surah!.englishName!,
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
            /*Text(
                getText.isEmpty ? "" : "604",
                textAlign: TextAlign.left,
              ),*/
          ],
        )
      ],
    ));
  }

  //Widget quranPageListText(FollowQuranViewModel _fqvmProvider) {
  Widget quranPageListText(
      FollowQuranViewModel _fqvmProvider, BuildContext context) {
    return ListView(
      controller: _scrollController,
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
              /* print((_fqvmProvider.aktifsurah - 1).toString() +
                  " - " +
                  listNumber.toString());*/
              return TextSpan(
                style: listNumber == aktifsurah - 1
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
                    await stopAudio();
                    _fqvmProvider.getAyahList = getText;
                    aktifsurah = listNumber + 1;
                    playAudio(path: e.audioSecondary![1]);

                    // print(aktifsurah);
                    // setState(() {});
                  },
                children: [
                  WidgetSpan(
                      child: CircleAvatar(
                    radius: 10,
                    child: Text(_followQuranViewModel
                        .convertToArabicNumber(e.numberInSurah!)),
                  )),
                  /* TextSpan(
                                  text: " ﴿" +
                                      _followQuranViewModel
                                          .convertToArabicNumber(
                                              e.numberInSurah) +
                                      "﴾ ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.deepOrangeAccent),
                                ),*/
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
