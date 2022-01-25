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
      style:nightMode!=null? TextStyle(color: !nightMode ? Colors.black : Colors.white):null,
    ),
   iconTheme:nightMode!=null? IconThemeData(color: !nightMode ? Colors.black : Colors.white):null,
    backgroundColor: backColor ?? Colors.transparent,
    elevation: 0.0,
    leading: IconButton(
      icon: Icon(Icons.arrow_back,
          color:nightMode!=null? !nightMode ? Colors.black : Colors.white:null,),
      onPressed: () => Navigator.of(context!).pop(),
    ),
  );
}
