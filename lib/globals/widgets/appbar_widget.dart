import 'package:flutter/material.dart';

AppBar appBarWidget({
  BuildContext? context,
  bool? nightMode = false,
  String? titleTxt,
  Color? backColor,
}) {
  return AppBar(
    title: Text(
      titleTxt ?? "",
      style: TextStyle(color: !nightMode! ? Colors.black : Colors.white),
    ),
    iconTheme: IconThemeData(color: !nightMode ? Colors.black : Colors.white),
    backgroundColor: backColor ?? Colors.transparent,
    elevation: 0.0,
    leading: IconButton(
      icon: Icon(Icons.arrow_back,
          color: !nightMode ? Colors.black : Colors.white),
      onPressed: () => Navigator.of(context!).pop(),
    ),
  );
}
