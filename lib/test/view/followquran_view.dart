import 'package:flutter/material.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/test/model/followquran_model.dart';
import 'package:kuran/test/viewmodel/followquran_viewmodel.dart';

class FollowQuranView extends StatefulWidget {
  const FollowQuranView({Key? key}) : super(key: key);

  @override
  _FollowQuranViewState createState() => _FollowQuranViewState();
}

class _FollowQuranViewState extends State<FollowQuranView> {
  var _followQuranViewModel = FollowQuranViewModel();
  String pagetext = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsyc();
  }

  initAsyc() async {
    List? getText =
        await _followQuranViewModel.getText(pageNo: 2, kariId: "ar.alafasy");
    pagetext = "";
    getText!.map((e) {
      print(e.text);
      pagetext += e.text;
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
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: ListView(
                children: pagetext == ""
                    ? [
                        Center(
                          child: CircularProgressIndicator(),
                        )
                      ]
                    : [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                pagetext,
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
              ),
            ),
          );
        },
      ),
    );
  }
}
