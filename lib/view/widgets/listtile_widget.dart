import 'package:flutter/material.dart';

ListTile? ListTileWidget(Map<int, int> map) {
  map.forEach((key, value) {
    ListTile(
      title: Text(key.toString() + ".Juz"),
      onTap: () {},
    );
  });
}
