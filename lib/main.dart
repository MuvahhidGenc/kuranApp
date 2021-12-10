import 'package:flutter/material.dart';
import 'package:kuran/test/model/user_model.dart';
import 'package:kuran/test/view/hivetest_view.dart';
import 'package:kuran/test/view/testpdf_view.dart';
import 'package:kuran/view/home/home_view.dart';
import 'package:kuran/test/view/testpdfcached_view.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kuran/view/kuran/view/kuran_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Hive Database Başlatıldı
  Hive.registerAdapter(UserAdapter());

  await Hive.openBox<User>("users");
  await Hive.openBox("kuranPage");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'kuran',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (contex) =>const HomeView(),
        'kuran':(context)=>const Kuran(),
      },
    );
  }
}
