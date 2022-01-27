import 'package:flutter/material.dart';
getDialog({required BuildContext context,required String title,Widget? content,required List<TextButton> actions}){
   showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title:  Text(title),
          content: content,
          actions: actions,
        ),
      );
}
