import 'package:flutter/material.dart';
import 'package:kuran/globals/extantions/hivedb.dart';

class SwichListTileWidget extends StatelessWidget {
  final String hiveDbKey;
  final bool? value;

  const SwichListTileWidget({this.value, required this.hiveDbKey, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: ListTile(
        title: SwitchListTile(
            value: value!,
            title: const Text("Arapça Metin"),
            secondary: Icon(Icons.book_online_outlined),
            onChanged: (bool? val) async {
              //value = !val!;
              await HiveDb().putBox(hiveDbKey, value);
            }),
      ),
    );
  }
}
