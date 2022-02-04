import 'package:carousel_images/carousel_images.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kuran/globals/extantions/extanstion.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
];

class CarouselSliderWidget extends StatefulWidget {
  const CarouselSliderWidget({Key? key}) : super(key: key);

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  int _current = 0;

  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(title: Text('MUSHAFLAR')),
        body: Stack(
      children: [
        Center(
          child: CarouselImages(
            scaleFactor: 0.5,
            listImages: imgList,
            height: SnippetExtanstion(context).media.size.height * 0.9,
            borderRadius: 30.0,
            cachedNetworkImage: true,
            verticalAlignment: Alignment.topCenter,
            onTap: (index) {
              print('Tapped on page $index');
            },
          ),
        ),
        Positioned(
          child: Center(
              child: Container(
            height: SnippetExtanstion(context).media.size.height * 0.9,
            width: SnippetExtanstion(context).media.size.width * 0.88,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(40.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      TextButton(onPressed: (){}, child: Text("data"))
                  ],
                ),
          )),
        )
      ],
    ));
  }
}
