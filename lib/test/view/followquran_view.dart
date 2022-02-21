import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
    initAsyc();
  }

  initAsyc() async {
    getText =
        await _followQuranViewModel.getText(pageNo: 2, kariId: "ar.alafasy");
    pagetext = "";

    getText!.map((e) {
      print(e.text);
      pagetext += _followQuranViewModel.convertToArabicNumber(e.numberInSurah) +
          " " +
          e.text;
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
      ),
      body: PageView.builder(
        itemCount: 604,
        itemBuilder: (context, index) {
          // ignore: avoid_unnecessary_containers
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: getText?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        maxRadius: 15,
                        child: Text(_followQuranViewModel.convertToArabicNumber(
                            getText?[index].numberInSurah)),
                      ),
                      Flexible(
                        child: Text(
                          "  " + getText?[index].text.trim(),
                          //overflow: TextOverflow.ellipsis,
                          //  locale: Locale("UAE","971"),
                          //softWrap: false,
                          // style: TextStyle(fontSize: 20,fontFamily: 'arabic'),
                          style: TextStyle(fontSize: 25),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}