import 'package:flutter/material.dart';

class IconButonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback voidCallback;
  const IconButonWidget(
      {required this.icon, required this.voidCallback, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: voidCallback,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
