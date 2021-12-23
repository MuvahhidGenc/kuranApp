import 'package:flutter/material.dart';
import 'package:kuran/globals/constant/hivedb_constant.dart';
import 'package:kuran/globals/extantions/hivedb.dart';

Drawer drawerList(
    {BuildContext? context, bool? nightMode = false, Future<void>? callBack}) {
  return Drawer(
    elevation: 0.0,
    child: Container(
      color: Colors.transparent,
      child: ListView(
        children: [
          const Padding(
              padding: EdgeInsets.symmetric(
            vertical: 10.0,
          )),
          // SwitchListTile(
          //     value: nightMode!,
          //     title: const Text("Gece Modu "),
          //     secondary: Icon(Icons.nightlight),
          //     onChanged: (bool? val) {
          //       nightMode = val!;
          //       HiveDb().putBox(HiveDbConstant.NIGHTMODE, nightMode);
          //       Navigator.pushReplacement(context!,
          //           MaterialPageRoute(builder: (context) => context.widget));
          //     }),
        ],
      ),
    ),
  );
}
