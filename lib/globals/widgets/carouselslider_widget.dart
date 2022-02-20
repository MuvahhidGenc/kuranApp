import 'package:carousel_images/carousel_images.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kuran/globals/constant/constant.dart';
import 'package:kuran/globals/constant/urls_constant.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/view/kuran/view/kuran_view.dart';

/*final List<String> imgList = [
  'assets/images/mushaf.png',
  'assets/images/mushaf-tejweed.png',
  'assets/images/mushaf-2.png',
];*/

class CarouselSliderWidget extends StatefulWidget {
  const CarouselSliderWidget({Key? key}) : super(key: key);

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  /* final Map<String, String> imgList = {
    'assets/images/mushaf.png': "Mushaf",
    'assets/images/mushaf-tejweed.png': "Tecvidli Mushaf",
    'assets/images/mushaf-2.png': "Mushaf - 2",
  };*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = SnippetExtanstion(context).theme;
    var media = SnippetExtanstion(context).media;
    return Scaffold(
      body: Center(
        child: CarouselSlider(
          items: Constant.MUSHAFIMAGELIST.entries.map((item) {
            return GestureDetector(
              onTap: () {
                var url = "";
                if (item.value == "Mushaf") {
                  url = UrlsConstant.PDF_MUSHAF_URL;
                } else if (item.value == "Tecvidli Mushaf") {
                  url = UrlsConstant.PDF_MUSHAF_TECVID_URL;
                } else if (item.value == "Mushaf - 2") {
                  url = UrlsConstant.PDF_MUSHAF2_URL;
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Kuran(
                      url: url,
                      name: item.value,
                    ),
                  ),
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.asset(
                          item.key,
                          fit: BoxFit.fill,
                          height: media.size.height * 0.9,
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            height: media.size.height * 0.9,
                            decoration: BoxDecoration(
                              color: theme.textTheme.bodyText1!.color!
                                  .withOpacity(0.5),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      color:
                                          theme.listTileTheme.iconColor == null
                                              ? Colors.black.withOpacity(0.6)
                                              : theme.listTileTheme.iconColor!
                                                  .withOpacity(0.6),
                                      width: media.size.width,
                                      height: media.size.height * 0.1,
                                      child: Center(
                                        child: Text(
                                          item.value,
                                          style: TextStyle(
                                              color: theme
                                                  .textTheme.bodyText1!.color,
                                              fontSize: theme.textTheme
                                                  .headline5!.fontSize),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            );
          }).toList(),
          options: CarouselOptions(
              height: media.size.height * 0.9,
              viewportFraction: 0.8,
              enlargeCenterPage: true,
              autoPlay: false,
              aspectRatio: 0.5,
              disableCenter: true,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
      ),
    );
  }
}
