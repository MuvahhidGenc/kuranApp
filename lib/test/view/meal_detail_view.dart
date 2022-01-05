import 'package:flutter/material.dart';
import 'package:kuran/test/viewmodel/surah_versebyverse_viewmodel.dart';
import 'package:provider/provider.dart';

class MealDetailView extends StatefulWidget {
  int id;
  String surahName;
  MealDetailView({required this.id, required this.surahName, Key? key})
      : super(key: key);

  @override
  _MealDetailViewState createState() => _MealDetailViewState();
}

class _MealDetailViewState extends State<MealDetailView> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<SurahVerseByVerseViewModel>(context, listen: false)
        .getMealDetail(surahId: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName + " Süresi"),
      ),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, i) {
            return Card(
              // ignore: prefer_const_literals_to_create_immutables
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Arapça Metin Gelecek"),
                    Divider(
                      height: 5,
                    ),
                    Text("Latince Metin Gelecek"),
                    Divider(
                      height: 5,
                    ),
                    Text("Türkçe Metin Gelecek"),
                    Divider(
                      height: 5,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
