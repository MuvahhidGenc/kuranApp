import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initAsyc();
  }

  initAsyc(int page) async {
    getText =
        await _followQuranViewModel.getText(pageNo: page, kariId: "ar.alafasy");
    pagetext = "";
    
    getText!.map((e) {
      print(e.text);
      pagetext +=" ﴿ "+ _followQuranViewModel.convertToArabicNumber(e.numberInSurah) +
           " ﴾  " +
          e.text;
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
   var theme=SnippetExtanstion(context).theme;
    return Scaffold(
      appBar: AppBar(
        title: Text("data",textAlign: TextAlign.left,),
      ),
      body: PageView.builder(

        itemCount: 604,
        itemBuilder: (context, index) {
           initAsyc(index+1);
          // ignore: avoid_unnecessary_containers
          return SafeArea(
          /*  width: MediaQuery.of(context).size.width * 0.9,*/
           /* decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
            ),*/
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child:Container(
        child: //Text(pagetext)
         ListView.builder(
                shrinkWrap: true,
                itemCount: getText?.length,
                itemBuilder: (BuildContext context, int index) {
                  return  /*RichText(text: TextSpan(
                    children: [
                      TextSpan(text:_followQuranViewModel.convertToArabicNumber(
                            getText?[index].numberInSurah)),
                      TextSpan(text:getText?[index].text.trim() ),
                    ]
                  ));*/ListTile(
                    tileColor:theme.backgroundColor,
                        leading: CircleAvatar(
                        maxRadius: 12,
                        child: Text(_followQuranViewModel.convertToArabicNumber(
                            getText?[index].numberInSurah)),
                      ),
                        title: Text(
                          "  " + getText?[index].text.trim(),
                          //overflow: TextOverflow.ellipsis,
                          //  locale: Locale("UAE","971"),
                          //softWrap: false,
                           style: TextStyle(fontSize: 20,fontFamily: 'arabic'),
                          
                          textAlign: TextAlign.right,
                        ),
                      );
                },
              ),
            ),
            ),
          );
        },
      ),
    );
  }
}
