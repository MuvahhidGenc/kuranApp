import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/test/viewmodel/followquran_viewmodel.dart';
import 'package:provider/provider.dart';

class FollowQuranView extends StatefulWidget {
  const FollowQuranView({Key? key}) : super(key: key);

  @override
  _FollowQuranViewState createState() => _FollowQuranViewState();
}

class _FollowQuranViewState extends State<FollowQuranView> {
  var _followQuranViewModel = FollowQuranViewModel();
  List? getText;

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
        title: Text(
          "data",
          textAlign: TextAlign.left,
        ),
      ),
      body: PageView.builder(
        itemCount: 604,
        onPageChanged: (int page) {
          print(page);
          provider.aktifsurah = 1;
          setState(() {});
        },
        itemBuilder: (context, index) {
          // ignore: avoid_unnecessary_containers
          return Padding(
            padding: const EdgeInsets.all(15.0),
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
          Icons.play_circle,
          size: 40,
        ),
        onPressed: () {
          var path = getText![0].audioSecondary[1];
          provider.playAudio(path: path);
        },
      ),
    );
  }

  ListView quranPageListText(FollowQuranViewModel _fqvmProvider) {
    return ListView(
      children: [
        RichText(
          overflow: TextOverflow.clip,
          textScaleFactor: 1.1,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          text: TextSpan(
            style: TextStyle(
                fontSize: 25,
                color: SnippetExtanstion(context).theme.primaryColorLight),
            children: getText?.map((e) {
              return TextSpan(
                style: e.numberInSurah == _fqvmProvider.aktifsurah
                    ? TextStyle(
                        backgroundColor: Colors.grey[400],
                      )
                    : null,
                text: " " + e.text.trim() + " ",
                children: [
                  WidgetSpan(
                      child: CircleAvatar(
                    radius: 15,
                    child: Text(_followQuranViewModel
                        .convertToArabicNumber(e.numberInSurah)),
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
