import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  var itemKey = GlobalKey();

  Future quranGetText(int page) async {
    getText =
        await _followQuranViewModel.getText(pageNo: page, kariId: "ar.alafasy");

    return getText;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<FollowQuranViewModel>(context, listen: false)
        .audioPlayerStream();
  }

  @override
  Widget build(BuildContext context) {
    var theme = SnippetExtanstion(context).theme;
    var provider = Provider.of<FollowQuranViewModel>(context);
    return Scaffold(
      backgroundColor: theme.listTileTheme.iconColor,
      appBar: AppBar(
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
        ),
      ),
      body: PageView.builder(
        controller: provider.pageController,
        itemCount: 604,
        onPageChanged: (int page) async {
          provider.getAyahList = getText;
          provider.aktifsurah = 1;
          getText = await provider.getText(pageNo: page, kariId: "ar.alafasy");
          // var path = getText[0].audioSecondary![1];
          // provider.playAudio(path: path);
        },
        itemBuilder: (context, index) {
          // ignore: avoid_unnecessary_containers
          return Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Container(
              child: FutureBuilder(
                  future: quranGetText(index + 1),
                  builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                    if (asyncSnapshot.hasData) {
                      return quranPageListText(provider);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          provider.floattingActionButtonIcon ?? Icons.play_circle_fill,
          size: 40,
        ),
        onPressed: () {
          provider.getAyahList = getText;
          var deger = provider.aktifsurah = 1;
          print(deger);
          var path = getText[0].audioSecondary![1];
          provider.playAudio(path: path);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  ListView quranPageListText(FollowQuranViewModel _fqvmProvider) {
    return ListView(
      shrinkWrap: true,
      children: [
        RichText(
          overflow: TextOverflow.clip,
          textScaleFactor: 1.1,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          text: TextSpan(
            style: TextStyle(
                fontSize: 28,
                color: SnippetExtanstion(context).theme.primaryColorLight),
            children: getText.map((e) {
              var listNumber = getText.indexOf(e);
              print("İndis : " +
                  listNumber.toString() +
                  " aktif : " +
                  _fqvmProvider.aktifsurah.toString());
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
