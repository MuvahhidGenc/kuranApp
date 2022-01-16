import 'package:hive/hive.dart';
import 'package:kuran/globals/constant/hivedb_constant.dart';
import 'package:kuran/test/model/hive_favorilerim_model.dart';

class HiveBoxes {
  static Box<HiveFavorilerimModel> faroviAyetlerimBox() =>
      Hive.box(HiveDbConstant.FAVORIAYETLERIM);
}
