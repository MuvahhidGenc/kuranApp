import 'package:flutter/material.dart';
import 'package:kuran/globals/widgets/carouselslider_widget.dart';

class Mushafs extends StatefulWidget {
  const Mushafs({ Key? key }) : super(key: key);

  @override
  _MushafsState createState() => _MushafsState();
}

class _MushafsState extends State<Mushafs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:CarouselSliderWidget(),
    );
  }
}