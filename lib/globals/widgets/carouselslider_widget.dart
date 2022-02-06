import 'package:carousel_images/carousel_images.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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
  var url = "";
  final CarouselController _controller = CarouselController();
  final Map<String, String> imgList = {
    'assets/images/mushaf.png': "Mushaf",
    'assets/images/mushaf-tejweed.png': "Tecvidli Mushaf",
    'assets/images/mushaf-2.png': "Mushaf - 2",
  };
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
          items: imgList.entries.map((item) {
            return GestureDetector(
              onTap: () {
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
                              /*gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(200, 0, 0, 0),
                                        Color.fromARGB(0, 0, 0, 0)
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),*/
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
                                    /*  Icon(
                                      Icons.downloading,
                                      color: theme.listTileTheme.iconColor,
                                      size: theme.textTheme.headline1!.fontSize,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),*/
                                    Container(
                                      color: theme.listTileTheme.iconColor!
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
      /*body: Center(
        child: Container(
          height: media.size.height * 0.9,
          child: CarouselSlider.builder(
            itemCount: 3,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) =>
                    GestureDetector(
              onTap: () {
                print("$itemIndex");
              },
              child: Container(
                height: media.size.height,
                color: Colors.black.withOpacity(0.9),
                child: Image.network(
                  imgList[itemIndex],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            options: CarouselOptions(
                height: media.size.height * 0.9,
                viewportFraction: 0.8,
                enlargeCenterPage: true,
                autoPlay: false,
                aspectRatio: 0.1,
                disableCenter: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
        ),
      ),*/
      //appBar: AppBar(title: Text('MUSHAFLAR')),
      /*  body: Stack(
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
              children: [TextButton(onPressed: () {}, child: Text("data"))],
            ),
          )),
        )
      ],
    )*/
    );
  }
}
