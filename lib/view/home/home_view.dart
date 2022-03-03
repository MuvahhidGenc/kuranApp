import 'package:flutter/material.dart';
import 'package:kuran/globals/base/theme/theme_base.dart';
import 'package:kuran/globals/constant/apptitles_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/view/favorikaldigimyer/view/favoriayetlerim_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    var theme = SnippetExtanstion(context).theme;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppTitlesConstant.MAIN_VIEW_TITLE),
          actions: [
            IconButton(
              onPressed: () {
                Provider.of<AppThemeBase>(context, listen: false)
                    .changeStateTheme();
              },
              icon: Icon(Icons.brightness_4),
            )
          ],
        ),
        bottomNavigationBar: bottomTabbarWidget(theme),
        body: TabBarView(
          children: [
            homeWidget(context, theme),
            FavoriAyetlerimView(nerden: "favori"),
            FavoriAyetlerimView(nerden: "kaldigimyer"),
          ],
        ),
      ),
    );
  }

  Padding homeWidget(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Container(
            height: SnippetExtanstion(context).media.size.height * 0.3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                color: SnippetExtanstion(context).theme.primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  )
                ]),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Hiç şüphesiz, bu Kur'an, sana, hüküm ve hikmet sahibi olan, (ve her şeyi gerçeğiyle) bilen (Allah'ın) katından ilka edilmektedir.\n \n Neml suresi 6. ayet",
                    style: TextStyle(
                      color: theme.listTileTheme.iconColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: Container(
              child: GridView(
                padding: EdgeInsets.all(5),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 8,
                    crossAxisCount: 3),
                children: [
                  _mainButton(
                      buttonName: "Mushaf",
                      link: "mushafs",
                      icon: Icons.menu_book),
                  _mainButton(
                      buttonName: "Meal",
                      link: "meal",
                      icon: Icons.import_contacts),
                  _mainButton(
                      buttonName: "Kur'an Dinle",
                      link: "kuranMp3",
                      icon: Icons.play_lesson),
                  _mainButton(
                      buttonName: "Arapça Türkçe Sesli Meal",
                      link: "trarMp3",
                      icon: Icons.headphones),
                  _mainButton(
                      buttonName: "İhtiyaç Sahipleri",
                      link: "infak",
                      icon: Icons.volunteer_activism),
                  _mainButton(
                      buttonName: "Takipli Kuran",
                      link: "flowquran",
                      icon: Icons.play_lesson),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container bottomTabbarWidget(ThemeData theme) {
    return Container(
      color: theme.primaryColor,
      child: TabBar(
          indicator: BoxDecoration(color: theme.listTileTheme.tileColor),
          tabs: [
            Tab(
              icon: Icon(Icons.home),
              text: "Anasayfa",
            ),
            Tab(
              icon: Icon(Icons.star),
              text: "Favori Ayetlerim",
            ),
            Tab(icon: Icon(Icons.bookmark), text: "Kaldığım Yerler"),
          ]),
    );
  }

  GestureDetector _mainButton(
      {required String buttonName,
      required String link,
      required IconData icon}) {
    var themeProvider = Provider.of<AppThemeBase>(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(link);
      },
      child: Container(
        decoration: BoxDecoration(
            color: SnippetExtanstion(context).theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ]),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              // backgroundColor: Colors.grey[300],
              radius: 25,
              child: Icon(
                icon,
                size: 30,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Text(
                buttonName,
                style: TextStyle(
                  color: SnippetExtanstion(context).theme.primaryColorLight,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
