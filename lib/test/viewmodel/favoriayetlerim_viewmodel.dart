import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:kuran/test/model/hive_favorilerim_model.dart';
import 'package:kuran/test/snippet/hive_boxes.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FavoriAyetlerimViewModel extends ChangeNotifier {
  Box<HiveFavorilerimModel>? box;
  ItemPositionsListener itemPositionListener = ItemPositionsListener.create();
  ItemScrollController itemController = ItemScrollController();

  addFovoriAyetim(
      {required String arabicText,
      required String latinText,
      required String turkishText,
      required int surahNo,
      required int ayahNo,
      required String surahName}) {
    HiveFavorilerimModel data = HiveFavorilerimModel(
      arabicText: arabicText,
      latinText: latinText,
      turkishText: turkishText,
      surahNo: surahNo,
      surahName: surahName,
      ayahNo: ayahNo,
    );
    box = HiveBoxes.faroviAyetlerimBox();
    box!.add(data);
  }

  scrollGotoIndex(int index) {
    if (itemController.isAttached) {
      itemController.scrollTo(
          index: index,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOutCubic);
    }
  }

  waitScrolWork(int gotoAyah) {
    gotoAyah != null
        ? Future.delayed(Duration(seconds: 1), () {
            if (!itemController.isAttached)
              Future.delayed(
                  Duration(seconds: 1), () => scrollGotoIndex(gotoAyah));
            else
              scrollGotoIndex(gotoAyah);
          })
        : null;
  }

  

}
