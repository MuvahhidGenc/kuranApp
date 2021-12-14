import 'package:flutter/material.dart';
import 'package:kuran/constains/apptitles_constains.dart';
import 'package:kuran/extantions/extanstion.dart';

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
        title: const Text(AppTitlesConstains.MAIN_VIEW_TITLE),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 150,
                color: context.theme.colorScheme.background,
                child: Text(
                  "Ey iman edenler! Sabır ve namazla yardım dileyin. Şüphesiz Allah sabredenlerin yanındadır. \n \t Bakara 153",
                  style: context.theme.textTheme.headline5,
                ),
              ),
              SizedBox(height: 10,),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed("kuran");
                },
                icon: Icon(Icons.book),
                label: Text("Kuran"),
              )
            ],
          ),
        ),
      ),
    );
  }
}