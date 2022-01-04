import 'package:flutter/material.dart';
import 'package:kuran/test/viewmodel/surah_versebyverse_viewmodel.dart';
import 'package:provider/provider.dart';

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
    initAsyc();
    super.initState();
    Provider.of<SurahVerseByVerseViewModel>(context).getSureName();
  }

  initAsyc() async {
    await _surahVerseByVerseViewModel.getSureName();
  }

  @override
  Widget build(BuildContext context) {
    var provider=Provider.of<SurahVerseByVerseViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Kuran'ı Kerim Türkçe Meal"),
      ),
      body: surahListBuilderWidget(provider)
    );
  }


  Widget surahListBuilderWidget(SurahVerseByVerseViewModel provider){
    if(provider.sureNameModel.data!=null){
       return ListView.builder(itemCount: provider.sureNameModel.data!.length,itemBuilder: (context,i){
        return ListTile(
          title: Text("Test $i"),
        );
    });
    }else{
      return Center(child: CircularProgressIndicator(),);
    }
   
  }



}
