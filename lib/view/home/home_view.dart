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
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTitlesConstant.MAIN_VIEW_TITLE),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 150,
                color: context.theme.colorScheme.background,
                alignment: Alignment.centerRight,
                child: Text(
                  "Ey iman edenler! Sabır ve namazla yardım dileyin. Şüphesiz Allah sabredenlerin yanındadır. \n \t Bakara 153",
                  style: context.theme.textTheme.headline5,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed("kuran");
                },
                icon: Icon(Icons.book),
                label: Text("Kuran"),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed("kuranMp3");
                },
                icon: Icon(Icons.book),
                label: Text("Kuran Mp3"),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed("trarMp3");
                },
                icon: Icon(Icons.book),
                label: Text("Türkçe Arapça Kuran Mp3"),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed("meal");
                },
                icon: Icon(Icons.book),
                label: Text("Meal"),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed("favorilerim");
                },
                icon: Icon(Icons.book),
                label: Text("Favorilerim"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
