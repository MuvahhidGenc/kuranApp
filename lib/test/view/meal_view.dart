import 'package:flutter/material.dart';
import 'package:kuran/test/viewmodel/surah_versebyverse_viewmodel.dart';

class MealView extends StatefulWidget {
  const MealView({Key? key}) : super(key: key);

  @override
  _MealViewState createState() => _MealViewState();
}

class _MealViewState extends State<MealView> {
  SurahVerseByVerseViewModel _surahVerseByVerseViewModel =
      SurahVerseByVerseViewModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _surahVerseByVerseViewModel.getSureName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kuran'ı Kerim Türkçe Meal"),
      ),
      body: Center(
        child: Text("Test"),
      ),
    );
  }
}
