import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kuran/globals/constant/apptitles_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
 
  @override
  Widget build(BuildContext context) {
     var theme=SnippetExtanstion(context).theme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTitlesConstant.MAIN_VIEW_TITLE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            SizedBox(height: 5,),
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
                ]
              ),
              alignment: Alignment.center,
              
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [ 
                    Text("Hiç şüphesiz, bu Kur'an, sana, hüküm ve hikmet sahibi olan, (ve her şeyi gerçeğiyle) bilen (Allah'ın) katından ilka edilmektedir.",style: TextStyle(color:theme.listTileTheme.iconColor ,fontSize: theme.textTheme.headline6!.fontSize),),
                    Text("Neml suresi 6. ayet",style: TextStyle(color:theme.listTileTheme.iconColor ,fontWeight: FontWeight.bold),),

                  ],
                ),
              ),
             
              
            ),
           SizedBox(height: 5,),
            Expanded(
              child: Container(
                
                child: GridView(
                  padding: EdgeInsets.all(5),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10, mainAxisSpacing: 8, crossAxisCount: 3),
                  children: [
                    _mainButton(
                        buttonName: "Mushaf",
                        link: "kuranMp3",
                        icon: Icons.menu_book),
                    _mainButton(
                        buttonName: "Meal",
                        link: "link",
                        icon: Icons.import_contacts),
                    _mainButton(
                        buttonName: "Kur'an Dinle",
                        link: "link",
                        icon: Icons.play_lesson),
                    _mainButton(
                        buttonName: "Arapça Türkçe Sesli Meal",
                        link: "link",
                        icon: Icons.headphones),
                         _mainButton(
                        buttonName: "İhtiyaç Sahipleri",
                        link: "link",
                        icon: Icons.volunteer_activism),
                         _mainButton(
                        buttonName: "Hakkımızda",
                        link: "link",
                        icon: Icons.group),
                           _mainButton(
                        buttonName: "İletişim",
                        link: "link",
                        icon: Icons.contact_mail),
                          _mainButton(
                        buttonName: "Öneri / Şikayet",
                        link: "link",
                        icon: Icons.connect_without_contact),
                              _mainButton(
                        buttonName: "Sıkça Sorulan Sorular",
                        link: "link",
                        icon: Icons.contact_support),
                  
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      /* namedRouting(context: context, link: "kuran", name: "Kuran"),
              namedRouting(
                  context: context, link: "kuranMp3", name: "Kuran Mp3"),
              namedRouting(
                  context: context,
                  link: "trarMp3",
                  name: "Türkçe Arapça Kuran Mp3"),
              namedRouting(context: context, link: "meal", name: "Meal"),
            
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed("favorilerim");
                },
                icon: Icon(Icons.book),
                label: Text("Favorilerim"),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed("kaldigimyerler");
                },
                icon: Icon(Icons.book),
                label: Text("Kaldığım Yerler"),
              ),*/
    );
  }

  GestureDetector _mainButton(
      {required String buttonName,
      required String link,
      required IconData icon}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(link);
      },
      child: Container(
        decoration: BoxDecoration(color: SnippetExtanstion(context).theme.scaffoldBackgroundColor, boxShadow: [
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
            Text(
              buttonName,
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

Column namedRouting(
    {required BuildContext context,
    required String link,
    required String name}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: 10,
      ),
      TextButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed(link);
        },
        icon: Icon(Icons.book),
        label: Text(name),
      ),
    ],
  );
}
