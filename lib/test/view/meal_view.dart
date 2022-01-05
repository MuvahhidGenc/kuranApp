import 'package:flutter/material.dart';
import 'package:kuran/test/view/meal_detail_view.dart';
import 'package:kuran/test/viewmodel/surah_versebyverse_viewmodel.dart';
import 'package:provider/provider.dart';

class MealView extends StatefulWidget {
  const MealView({Key? key}) : super(key: key);

  @override
  _MealViewState createState() => _MealViewState();
}

class _MealViewState extends State<MealView> {
  // SurahVerseByVerseViewModel _surahVerseByVerseViewModel =
  //     SurahVerseByVerseViewModel();
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<SurahVerseByVerseViewModel>(context, listen: false)
        .getSureName();
    initAsyc();
    super.initState();
  }

  initAsyc() async {
    //await _surahVerseByVerseViewModel.getSureName();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SurahVerseByVerseViewModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Kuran'ı Kerim Türkçe Meal"),
        ),
        body: surahListBuilderWidget(provider));
  }

  Widget surahListBuilderWidget(SurahVerseByVerseViewModel provider) {
    if (provider.sureNameModel.data != null) {
      return ListView.builder(
          itemCount: provider.sureNameModel.data!.length,
          itemBuilder: (context, i) {
            return Card(
              child: ListTile(
                leading: Icon(Icons.pageview),
                title: Text(provider.sureNameModel.data![i].name!),
                trailing: Text(provider.sureNameModel.data![i].nameOriginal!),
                subtitle: Text("Ayet Sayısı : " +
                    provider.sureNameModel.data![i].verseCount.toString()),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MealDetailView(
                          id: provider.sureNameModel.data![i].id!,
                          surahName: provider.sureNameModel.data![i].name!)));
                  /*Navigator.of(context).pushNamed("mealDetail",
                      arguments: {"id": provider.sureNameModel.data![i].id});*/
                },
              ),
            );
          });
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
