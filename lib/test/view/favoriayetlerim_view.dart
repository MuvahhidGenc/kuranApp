import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kuran/test/model/hive_favorilerim_model.dart';
import 'package:kuran/test/snippet/hive_boxes.dart';

class FavoriAyetlerimView extends StatelessWidget {
  FavoriAyetlerimView({Key? key}) : super(key: key);
  final Box<HiveFavorilerimModel>? _favoriBox = HiveBoxes.faroviAyetlerimBox();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favori Ayetlerim"),
      ),
      body: ValueListenableBuilder<Box<HiveFavorilerimModel>>(
          valueListenable: _favoriBox!.listenable(),
          builder: (context, box, widget) {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    title: Column(
                      children: [
                        Text(box.get(i)!.arabicText.toString()),
                        Text(box.get(i)!.latinText.toString()),
                        Text(box.get(i)!.turkishText.toString()),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
