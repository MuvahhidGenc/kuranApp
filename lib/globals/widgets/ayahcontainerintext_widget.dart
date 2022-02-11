import 'package:flutter/material.dart';

class AyahCardInTextWidget extends StatelessWidget {
  final Color color;
  final String ayah;
  final Alignment textPosition;
  final TextStyle? style;
  const AyahCardInTextWidget(
      {required this.color,
      required this.ayah,
      this.style,
      required this.textPosition,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      alignment: textPosition,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          ayah,
          style: style,
        ),
      ),
    );
  }
}
