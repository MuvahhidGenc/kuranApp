import 'package:flutter/material.dart';
import 'package:kuran/globals/constant/hivedb_constant.dart';
import 'package:kuran/globals/manager/network_manager.dart';
import 'package:kuran/test/model/hive_favorilerim_model.dart';
import 'package:kuran/test/snippet/hive_boxes.dart';
import 'package:kuran/test/view/favoriayetlerim_view.dart';
import 'package:kuran/test/view/meal_view.dart';
import 'package:kuran/test/viewmodel/favoriayetlerim_viewmodel.dart';
import 'package:kuran/test/viewmodel/surah_versebyverse_viewmodel.dart';
import 'package:kuran/view/karikuranmp3/view/kari_kuran_mp3_view.dart';
import 'package:kuran/view/trarmp3/view/trar_mp3_view.dart';
import 'package:kuran/view/trarmp3/viewmodel/trar_mp3_viewmodel.dart';
import 'package:provider/provider.dart';
import 'view/home/home_view.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'view/kuran/view/kuran_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Hive Database Başlatıldı
  Hive.registerAdapter(HiveFavorilerimModelAdapter());
  // Hive.registerAdapter(UserAdapter());

  // await Hive.openBox<User>("users");
  await Hive.openBox<HiveFavorilerimModel>(HiveDbConstant.FAVORIAYETLERIM);
  await Hive.openBox<HiveFavorilerimModel>(HiveDbConstant.KALDIGIMYER);
  await Hive.openBox("kuranPage");
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => TrArMp3ViewModel()),
    ChangeNotifierProvider(create: (_) => SurahVerseByVerseViewModel()),
    ChangeNotifierProvider(create: (_) => FavoriAyetlerimViewModel()),
  ], child: const MyApp()));
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
        brightness: Brightness.light,
        primarySwatch: Colors.brown,
        primaryColor: Colors.brown,
        scaffoldBackgroundColor: Colors.brown[100],
        listTileTheme: ListTileThemeData(
            tileColor: Colors.brown[300],
            textColor: Colors.brown[50],
            iconColor: Colors.brown[50]),
        drawerTheme: DrawerThemeData(backgroundColor: Colors.brown[100]),
        iconTheme: IconThemeData(color: Colors.brown),
        //colorScheme: ColorScheme(primary: primary, primaryVariant: primaryVariant, secondary: secondary, secondaryVariant: secondaryVariant, surface: surface, background: background, error: error, onPrimary: onPrimary, onSecondary: onSecondary, onSurface: onSurface, onBackground: onBackground, onError: onError, brightness: brightness)
        //accentIconTheme: ColorScheme(primary: primary, primaryVariant: primaryVariant, secondary: secondary, secondaryVariant: secondaryVariant, surface: surface, background: background, error: error, onPrimary: onPrimary, onSecondary: onSecondary, onSurface: onSurface, onBackground: onBackground, onError: onError, brightness: brightness),
      ),
      //ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (contex) => const HomeView(),
        'kuran': (context) => const Kuran(),
        'kuranMp3': (context) => KariKuranMp3View(),
        'trarMp3': (context) => TrArMp3View(),
        'meal': (context) => MealView(),
        'favorilerim': (context) => FavoriAyetlerimView(nerden: "favori",),
        'kaldigimyerler': (context) => FavoriAyetlerimView(nerden: "kaldigimyer",),
      },
    );
  }
}
