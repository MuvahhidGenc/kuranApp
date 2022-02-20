import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuran/view/infak/model/infak_model.dart';
import 'package:kuran/view/infak/viewmodel/infak_viewmodel.dart';

class InfakDetailView extends StatefulWidget {
  final InfakModelData infakModelData;
  const InfakDetailView({Key? key, required this.infakModelData})
      : super(key: key);

  @override
  _InfakDetailViewState createState() => _InfakDetailViewState();
}

class _InfakDetailViewState extends State<InfakDetailView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.infakModelData.isim!),
      ),
      body: ListView(
        children: [
          Container(
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 1.5,
                enlargeCenterPage: true,
              ),
              items: widget.infakModelData.delilgorsel!
                  .map((item) => Container(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              child: Stack(
                                children: <Widget>[
                                  Image.network(item,
                                      fit: BoxFit.cover, width: 1000.0),
                                  /*Positioned(
                                    bottom: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(200, 0, 0, 0),
                                            Color.fromARGB(0, 0, 0, 0)
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                      child: Text(
                                        'Hifa Bebek',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),*/
                                ],
                              )),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Card(
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    title: Text("Hesap Adı : " +
                        widget.infakModelData.hesapadi! +
                        "\nBanka İsmi : " +
                        widget.infakModelData.bankaisim! +
                        "\nValilik İzni : " +
                        widget.infakModelData.valilikizin!),
                  ),
                ),
                ibanTile(context,
                    iban: widget.infakModelData.ibantl!,
                    ibanCounty: 'İBAN TL : '),
                ibanTile(context,
                    iban: widget.infakModelData.ibanusd!,
                    ibanCounty: 'İBAN USD : '),
                ibanTile(context,
                    iban: widget.infakModelData.ibaneuro!,
                    ibanCounty: 'İBAN EURO : '),
                /* ibanTile(context,
                    iban: widget.infakModelData.bickodu!,
                    ibanCounty: 'BİC KODU : '),*/
                Card(
                  child: ListTile(
                    title: Text(widget.infakModelData.aciklama!),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Card ibanTile(BuildContext context,
      {required String iban, required String ibanCounty}) {
    return Card(
      child: ListTile(
        onTap: () {
          Clipboard.setData(ClipboardData(text: iban)).then((value) {
            final snackBar = SnackBar(
              content: Text('Kopyalama İşlemi Başarılı'),
            );
            //only if ->
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
        },
        title: Text(ibanCounty + iban),
        trailing: Icon(Icons.copy_all),
      ),
    );
  }
}
