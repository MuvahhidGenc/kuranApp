import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/test/viewmodel/followquran_viewmodel.dart';

class FollowQuranView extends StatefulWidget {
  const FollowQuranView({Key? key}) : super(key: key);

  @override
  _FollowQuranViewState createState() => _FollowQuranViewState();
}

class _FollowQuranViewState extends State<FollowQuranView> {
  var _followQuranViewModel = FollowQuranViewModel();
  String pagetext = "";
  List? getText;
  int aktifAyah = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    aktifAyah = 1;
    //initAsyc();
  }

  initAsyc(int page) async {
    // getText=[];
    getText =
        await _followQuranViewModel.getText(pageNo: page, kariId: "ar.alafasy");
    pagetext = "";

    /*getText!.map((e) {
      print(e.text);
      pagetext += " ﴿ " +
          _followQuranViewModel.convertToArabicNumber(e.numberInSurah) +
          " ﴾  " +
          e.text;
    }).toList();*/
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var theme = SnippetExtanstion(context).theme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "data",
          textAlign: TextAlign.left,
        ),
      ),
      body: PageView.builder(
        itemCount: 604,
        itemBuilder: (context, index) {
          initAsyc(index + 1);
          if (getText!.isEmpty || getText == null) {
            return CircularProgressIndicator();
          }
          // ignore: avoid_unnecessary_containers
          return SafeArea(
            /*  width: MediaQuery.of(context).size.width * 0.9,*/
            /* decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
            ),*/
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                /*decoration: BoxDecoration(
                  color: theme.textTheme.bodyText1!.color
                ),*/
                child: ListView(
                  children: [
                    RichText(
                        overflow: TextOverflow.clip,
                        textScaleFactor: 1.1,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16, /*color: theme.backgroundColor*/
                          ),
                          children: getText?.map((e) {
                            return TextSpan(
                              style: e.numberInSurah == aktifAyah
                                  ? TextStyle(
                                      backgroundColor: Colors.white,
                                      color: Colors.black)
                                  : null,
                              text: " "+e.text.trim()+" ",
                              children: [
                                WidgetSpan(child: CircleAvatar(radius: 10,child: Text( _followQuranViewModel
                                          .convertToArabicNumber(
                                              e.numberInSurah) ),)),
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
                        )),
                  ],
                ),
                //Text(pagetext)
                /* ListView.builder(
                shrinkWrap: true,
                itemCount: getText?.length,
                itemBuilder: (BuildContext context, int i) {*/
                //return
                /*RichText(
                        text: TextSpan(children: [
                 
                  TextSpan(text: getText?[i].text.trim()+""),
                   TextSpan(
                    text: _followQuranViewModel
                        .convertToArabicNumber(getText?[i].numberInSurah),
                  ),
                ])),*/ /*ListTile(
                    tileColor:theme.backgroundColor,
                        leading: CircleAvatar(
                        maxRadius: 12,
                        child: Text(_followQuranViewModel.convertToArabicNumber(
                            getText?[i].numberInSurah)),
                      ),
                        title: Text(
                          "  " + getText?[i].text.trim(),
                          //overflow: TextOverflow.ellipsis,
                          //  locale: Locale("UAE","971"),
                          //softWrap: false,
                           style: TextStyle(fontSize: 20,fontFamily: 'arabic'),
                          
                          textAlign: TextAlign.right,
                        ),
                      );*/
                // },
                // ),
              ),
            ),
          );
        },
      ),
    );
  }
}
