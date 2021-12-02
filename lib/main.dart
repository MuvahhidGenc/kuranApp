import 'package:flutter/material.dart';
import 'package:kuran/test/model/user_model.dart';
import 'package:kuran/test/view/hivetest_view.dart';
import 'package:kuran/view/home_view.dart';
import 'package:kuran/view/kurandownload_view.dart';
import 'package:kuran/view/testpdfcached_view.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Hive Database Başlatıldı
  Hive.registerAdapter(UserAdapter());

  await Hive.openBox<User>("users");
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
        '/': (contex) => const HiveNoSql(),
      },
    );
  }
}
