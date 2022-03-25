import 'package:flutter/material.dart';

getDialog(
    {required BuildContext context,
    required String title,
    Widget? content,
    required List<Widget> actions}) {
  showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: content,
            actions: actions,
          );
        });
      });
}
