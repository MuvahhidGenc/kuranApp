import 'package:hive/hive.dart';
import 'package:kuran/constains/hivedb_constains.dart';

class KuranPageHiveBoxes {
  static Future<Box> get getOpenKuranPageBox async =>
      await Hive.openBox(HiveDbConstains.kuranPageName);
  // Box get getKuranPageBox => getKuranPageBox.get(HiveDbConstains.kuranPageName);
}
