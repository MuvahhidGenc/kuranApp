import 'package:flutter/material.dart';
import 'package:kuran/view/kuran/view/kuran_view.dart';

ListTile? ListTileWidget(Map<int, int> map) {
  final kuran = new Kuran();
  map.forEach((key, value) {
    ListTile(
      title: Text(key.toString() + ".Juz"),
      onTap: () {},
    );
  });
}
