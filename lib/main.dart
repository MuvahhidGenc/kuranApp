import 'package:flutter/material.dart';
import 'package:kuran/globals/base/theme/theme_base.dart';
import 'package:kuran/globals/constant/hivedb_constant.dart';
import 'package:kuran/globals/extantions/theme_extanstion.dart';
import 'package:kuran/test/view/followquran_view.dart';
import 'package:kuran/view/infak/view/infak_view.dart';
import 'package:kuran/view/favorikaldigimyer/model/hive_favorilerim_model.dart';
import 'package:kuran/view/favorikaldigimyer/view/favoriayetlerim_view.dart';
import 'package:kuran/view/favorikaldigimyer/viewmodel/favoriayetlerim_viewmodel.dart';
import 'package:kuran/view/karikuranmp3/view/kari_kuran_mp3_view.dart';
import 'package:kuran/view/kuran/view/mushafs_view.dart';
import 'package:kuran/view/meal/view/meal_view.dart';
import 'package:kuran/view/meal/viewmodel/surah_versebyverse_viewmodel.dart';
import 'package:kuran/view/trarmp3/view/trar_mp3_view.dart';
import 'package:kuran/view/trarmp3/viewmodel/trar_mp3_viewmodel.dart';
import 'package:provider/provider.dart';
import 'view/home/home_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Hive Database Başlatıldı
  Hive.registerAdapter(HiveFavorilerimModelAdapter());
  // Hive.registerAdapter(UserAdapter());

  // await Hive.openBox<User>("users");
  await Hive.openBox<HiveFavorilerimModel>(HiveDbConstant.FAVORIAYETLERIM);
  await Hive.openBox<HiveFavorilerimModel>(HiveDbConstant.KALDIGIMYER);
  await Hive.openBox(HiveDbConstant.TEXTLATINVISIBLE);
  await Hive.openBox(HiveDbConstant.TEXTARABICVISIBLE);
  await Hive.openBox("kuranPage");
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => TrArMp3ViewModel()),
    ChangeNotifierProvider(create: (_) => SurahVerseByVerseViewModel()),
    ChangeNotifierProvider(create: (_) => FavoriAyetlerimViewModel()),
    ChangeNotifierProvider(create: (_) => AppThemeBase(darkMode: false)),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeBase>(
      builder: (BuildContext context, themeProvider, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'kuran',
          theme: themeProvider.getTheme,
          //ThemeData.dark(),
          initialRoute: '/',
          routes: {
            '/': (contex) => const HomeView(),
            'mushafs': (context) => const Mushafs(),
            'kuranMp3': (context) => KariKuranMp3View(),
            'trarMp3': (context) => TrArMp3View(),
            'meal': (context) => MealView(),
            'favorilerim': (context) => FavoriAyetlerimView(nerden: "favori"),
            'kaldigimyerler': (context) =>
                FavoriAyetlerimView(nerden: "kaldigimyer"),
            "flowquran": (context) => FollowQuranView(),
            "infak": (context) => InfakView(),
          },
        );
      },
    );
  }
}
