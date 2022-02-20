import 'package:flutter/material.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/view/infak/model/infak_model.dart';
import 'package:kuran/view/infak/view/infak_detail_view.dart';
import 'package:kuran/view/infak/viewmodel/infak_viewmodel.dart';

class InfakView extends StatefulWidget {
  const InfakView({Key? key}) : super(key: key);

  @override
  _InfakViewState createState() => _InfakViewState();
}

class _InfakViewState extends State<InfakView> {
  var _InfakViewModel = InfakViewModel();
  InfakModel? ihtiyacsahipler;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsyc();
  }

  initAsyc() async {
    ihtiyacsahipler = await _InfakViewModel.getIhtiyacSahipleri();
    setState(() {});
    // print(ihtiyacsahipler!.data![0].baslik);
  }

  @override
  Widget build(BuildContext context) {
    var media = SnippetExtanstion(context).media;
    var theme = SnippetExtanstion(context).theme;
    return Scaffold(
      appBar: AppBar(
        title: Text("İnfak"),
      ),
      body: ihtiyacsahipler != null
          ? ListView.builder(
              itemCount: ihtiyacsahipler!.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InfakDetailView(
                                infakModelData:
                                    ihtiyacsahipler!.data![index])));
                  },
                  child: Card(
                    child: ListTile(
                      title: Image.network(
                        ihtiyacsahipler!.data![index].delilgorsel![1],
                        height: media.size.height * 0.4,
                        fit: BoxFit.fill,
                      ),
                      subtitle: Column(
                        children: [
                          Divider(),
                          Text(
                            ihtiyacsahipler!.data![index].isim!,
                            style: TextStyle(
                                fontSize: theme.textTheme.headline5!.fontSize),
                          ),
                          Divider(),
                          Text(
                            ihtiyacsahipler!.data![index].aciklama!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ), /*ListView(
        children: [
          GestureDetector(
            onTap: () => print("İnfak Detail"),
            child: Card(
              child: ListTile(
                title: Image.network(
                  "http://zeygame.com/ihtiyacsahipleri/hifakirtay/gorsel/hifa2.jpg",
                  height: media.size.height * 0.4,
                  fit: BoxFit.fill,
                ),
                subtitle: Column(
                  children: [
                    Divider(),
                    Text(
                      "HİFA KIRTAY",
                      style: TextStyle(
                          fontSize: theme.textTheme.headline5!.fontSize),
                    ),
                    Divider(),
                    Text("SMA (Kemik Erime) HASTASI HİFA BEBEK"),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),*/
    );
  }
}
