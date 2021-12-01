import 'package:flutter/material.dart';
import 'package:kuran/view/home_view.dart';
import 'package:kuran/view/kurandownload_view.dart';
import 'package:kuran/view/testpdfcached_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'kuran',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (contex) => Cachedtest(),
      },
    );
  }
}
