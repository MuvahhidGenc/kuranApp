import 'package:flutter/material.dart';
import 'package:kuran/constains/apptitles_constains.dart';

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
      body: const Center(
        child: Text("Main App"),
      ),
    );
  }
}
