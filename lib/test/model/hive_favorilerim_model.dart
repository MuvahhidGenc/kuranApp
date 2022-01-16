import 'package:hive/hive.dart';
part 'hive_favorilerim_model.g.dart';

@HiveType(typeId: 0)
class HiveFavorilerimModel {
  @HiveField(0)
  String? arabicText;
  @HiveField(1)
  String? turkishText;
  @HiveField(2)
  String? latinText;
  @HiveField(3)
  int? id;
  @HiveField(4)
  int? surahNo;
  @HiveField(5)
  int? ayahNo;
  HiveFavorilerimModel(
      {this.id,
      this.arabicText,
      this.turkishText,
      this.latinText,
      this.surahNo,
      this.ayahNo});
}
