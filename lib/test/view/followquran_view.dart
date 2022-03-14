import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/globals/manager/network_manager.dart';
import 'package:kuran/globals/services/dio/request.dart';
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

  Future quranGetText(int page) async {
    getText =await Provider.of<FollowQuranViewModel>(context,listen: false).quranGetText(page);
    /*print(await GetPageAPI()
        .getFileSize(UrlsConstant.KURAN_MP3_TRAR_URL + "versebyverse/3.zip"));*/
    return getText;
  }

  @override
  void initState() {
    // TODO: implement initState
    fullScreen = false;
    super.initState();
    quranGetText(1);
    _followQuranViewModel=Provider.of<FollowQuranViewModel>(context, listen: false);
    _followQuranViewModel.audioPlayerStream();
    

    // quranGetText(1);
    //Provider.of<FollowQuranViewModel>(context, listen: false).aktifsurah = 1;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = SnippetExtanstion(context).theme;
    var provider = Provider.of<FollowQuranViewModel>(context);

    return Scaffold(
      backgroundColor: theme.listTileTheme.iconColor,
      appBar: !fullScreen ? appBar() : null,
      body: bodyPageView(provider, theme, context),
      floatingActionButton: fullScreen ? floatingActionBottom(provider) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      bottomNavigationBar: !fullScreen ? bottomNavigatorBar(provider) : null,
    );
  }

  ConvexAppBar bottomNavigatorBar(FollowQuranViewModel provider) =>
      ConvexAppBar(
        style: TabStyle.fixedCircle,
        backgroundColor: SnippetExtanstion(context).theme.primaryColor,
        items: [
          TabItem(icon: Icons.list, title: "Süreler"),
          TabItem(
              icon: Icons.speaker_notes_off,
              activeIcon: Icons.speaker_notes,
              title: "Meal"),
          TabItem(
              icon:
                  provider.floattingActionButtonIcon ?? Icons.play_circle_fill,
              title: "Play",
              isIconBlend: true),
          TabItem(icon: Icons.settings, title: "Ayarlar"),
          TabItem(icon: Icons.fullscreen, title: "Tam Ekran"),
        ],
        initialActiveIndex: 2,
        onTap: (int i) {
          if (i == 2) {
            provider.getAyahList = getText;
            provider.aktifsurah = 1;
            // print(provider.aktifsurah);
            var path = getText[0].audioSecondary![1];
            
            provider.playAudio(path: path);
          } else if (i == 4) {
            fullScreen = !fullScreen;
            setState(() {});
          }
        },
      );

  FloatingActionButton floatingActionBottom(FollowQuranViewModel provider) {
    return FloatingActionButton(
      child: Icon(
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
        print(page);
        // Provider.of<FollowQuranViewModel>(context).getAyahList = getText;
        // Provider.of<FollowQuranViewModel>(context).aktifsurah = 1;
       // print(page);
        getText = await quranGetText(page+1);
        provider.getAyahList = getText;
        print(getText[0].text);
        provider.aktifsurah = 1;
        await provider.stopAudio();
       

        // print(provider.aktifsurah);
        // var path = getText[0].audioSecondary![1];
        // provider.playAudio(path: path);
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
              child:quranPageListText(provider, context),
                  
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
              style: TextStyle(fontSize: 15),
            ),
            Text(
              getText.isEmpty
                  ? ""
                  : " Cüz : {${getText[0].juz.toString()} / 30}",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 15),
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
      shrinkWrap: true,
      children: [
        RichText(
          overflow: TextOverflow.clip,
          //textScaleFactor: 1.1,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          text: TextSpan(
            style: TextStyle(
                fontSize: 27,
                color: SnippetExtanstion(context).theme.primaryColorLight),
            children: getText.map((e) {
              var listNumber = getText.indexOf(e);
              /* print((_fqvmProvider.aktifsurah - 1).toString() +
                  " - " +
                  listNumber.toString());*/
              return TextSpan(
                style: listNumber == _fqvmProvider.aktifsurah - 1
                    ? TextStyle(
                        backgroundColor: Colors.grey,
                        fontFamily: 'KFGQPC Uthman Taha Naskh',
                      )
                    : TextStyle(
                        fontFamily: 'KFGQPC Uthman Taha Naskh',
                      ),
                text: " " + e.text!.trim() + " ",
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    _fqvmProvider.getAyahList = getText;

                    //_fqvmProvider.stopAudio();

                    Provider.of<FollowQuranViewModel>(context, listen: false)
                        .aktifsurah = listNumber + 1;

                    await Provider.of<FollowQuranViewModel>(context,
                            listen: false)
                        .onlyPlayAudio(path: e.audioSecondary![1]);

                    print(_fqvmProvider.aktifsurah);
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
