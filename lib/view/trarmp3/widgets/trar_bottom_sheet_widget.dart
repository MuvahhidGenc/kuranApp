import 'package:flutter/material.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/view/trarmp3/viewmodel/trar_mp3_viewmodel.dart';
import 'package:provider/provider.dart';

class TrArBottomSheetWidget extends StatefulWidget {
  const TrArBottomSheetWidget({Key? key}) : super(key: key);

  @override
  _TrArBottomSheetWidgetState createState() => _TrArBottomSheetWidgetState();
}

class _TrArBottomSheetWidgetState extends State<TrArBottomSheetWidget> {
 // TrArMp3ViewModel trArViewModelProvider = TrArMp3ViewModel();
  @override
  Widget build(BuildContext context) {
   print("bottom Sheet Rebuild Edildi");
    //var trArViewModelProvider = Provider.of<TrArMp3ViewModel>(context);
    var mediaQuery = SnippetExtanstion(context).media;
    return Consumer<TrArMp3ViewModel>(builder: (context,trArViewModel,child){
      print("object");
      return  Container(
      //color: SnippetExtanstion(context).theme.scaffoldBackgroundColor,
      width: mediaQuery.size.width,
      height: mediaQuery.size.height * 0.17,
      decoration: containerBoxDecoration(context),
      child: Column(
        children: [
          sliderAndLefRightTextWidgets(trArViewModel),
          bottomButtonWidgets(trArViewModel),
        ],
      ),
    );;
    });
   
  }

  Center bottomButtonWidgets(TrArMp3ViewModel trArViewModelProvider) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Row(
          children: [
            SizedBox(
              height: 0,
            ),
             previouseIconButon(trArViewModelProvider),
            playIconButonWidget(trArViewModelProvider),
            nextIconButonWidget(trArViewModelProvider)
          ],
        ),
      ),
    );
  }

  Expanded nextIconButonWidget(TrArMp3ViewModel trArViewModelProvider) {
    return Expanded(
      //Next Buttom
      child: IconButton(
          onPressed: () async => trArViewModelProvider
              .bottomSheetNextAndBack(work: "next"),
          icon: Icon(
            Icons.skip_next,
            size: SnippetExtanstion(context).media.size.height * 0.06,
          )),
    );
  }

  Expanded playIconButonWidget(TrArMp3ViewModel trArViewModelProvider) {
    return Expanded(
      //Play Buttom
      child: IconButton(
          onPressed: () async =>
              await trArViewModelProvider.bottomSheetPlayButtonClick(),
          icon: Icon(
            trArViewModelProvider.buttomSheetPlayIcon ?? Icons.play_circle,
            size: SnippetExtanstion(context).media.size.height * 0.06,
          )),
    );
  }

  Expanded previouseIconButon(TrArMp3ViewModel trArViewModelProvider) {
    return Expanded(
      // skip Previous Button
      child: IconButton(
          onPressed: () async => await trArViewModelProvider
              .bottomSheetNextAndBack(work: "previouse"),
          icon: Icon(
            Icons.skip_previous,
            size: SnippetExtanstion(context).media.size.height * 0.06,
          )),
    );
  }

  /* Padding sliderAndLefRightTextWidgets(TrArMp3ViewModel trArViewModelProvider) {
    
    return Padding(
      // Audio Slider Bar Left Right Text
      padding: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 0.0,
      ),
      child: Column(
        // Audio Sl
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                  "${trArViewModelProvider.position.inMinutes}:${trArViewModelProvider.position.inSeconds.remainder(60)}"),
              Expanded(child: sliderAdaptiveWidget(trArViewModelProvider)),
              Text(
                  "${trArViewModelProvider.duration.inMinutes}:${trArViewModelProvider.duration.inSeconds.remainder(60)}"),
            ],
          ),
        ],
      ),
    );
  }*/
  Padding sliderAndLefRightTextWidgets(TrArMp3ViewModel trArMp3ViewModel) {
    return Padding(
      // Audio Slider Bar Left Right Text
      padding: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 0.0,
      ),
      child: Column(
        // Audio Sl
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              //Text("data"),
              Selector<TrArMp3ViewModel, Duration>(
                builder: (context, position, child) {
                
                  return Text(
                      '${position.inMinutes}:${position.inSeconds.remainder(60)}');
                },
                selector: (buildContext, duration) => duration.position,
              ),
              /*Text(
                  "${trArViewModelProvider.position.inMinutes}:${trArViewModelProvider.position.inSeconds.remainder(60)}"),*/
              // Expanded(child: sliderAdaptiveWidget(trArViewModelProvider)),
              Expanded(
                child: Selector<TrArMp3ViewModel, List<Duration>>(
                 
                  builder: (context, data, child) {
                  
                    return Slider.adaptive(
                        value: data[1].inSeconds.toDouble(),
                        max: data[0].inSeconds.toDouble(),
                        onChanged: (val) {
                          final durations = data[0];
                          if (durations == null) {
                            return;
                          }
                          final positions = val;
                          if (positions < data[0].inSeconds.toDouble()) {
                           trArMp3ViewModel.audioPlayer
                                .seek(Duration(seconds: positions.round()));
                          }
                        });
                  }, selector: (buildContext, duration) => duration.audioDuraiton,
                ),
              ),

              Selector<TrArMp3ViewModel, Duration>(
                selector: (buildContext, duration) => duration.duration,
                builder: (context, data, child) {
                
                  return Text(
                      '${data.inMinutes}:${data.inSeconds.remainder(60)}');
                },
                
              ),
              /*Text(
                  "${trArViewModelProvider.duration.inMinutes}:${trArViewModelProvider.duration.inSeconds.remainder(60)}"),*/
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration containerBoxDecoration(BuildContext context) {
    return BoxDecoration(
        color: SnippetExtanstion(context).theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: SnippetExtanstion(context).theme.scaffoldBackgroundColor,
              spreadRadius: 3,
              blurRadius: 3.0)
        ]);
  }

  /*Slider sliderAdaptiveWidget(TrArMp3ViewModel trArViewModelProvider) {
    return Slider.adaptive(
        value: trArViewModelProvider.position.inSeconds.toDouble(),
        max: trArViewModelProvider.duration.inSeconds.toDouble(),
        onChanged: (val) {
          final durations = trArViewModelProvider.duration;
          if (durations == null) {
            return;
          }
          final positions = val;
          if (positions < trArViewModelProvider.duration.inSeconds.toDouble())
            trArViewModelProvider.audioPlayer
                .seek(Duration(seconds: positions.round()));
        });
  } */
  Slider sliderAdaptiveWidget(TrArMp3ViewModel trArViewModelProvider) {
    return Slider.adaptive(
        value: trArViewModelProvider.position.inSeconds.toDouble(),
        max: trArViewModelProvider.duration.inSeconds.toDouble(),
        onChanged: (val) {
          final durations = trArViewModelProvider.duration;
          if (durations == null) {
            return;
          }
          final positions = val;
          if (positions < trArViewModelProvider.duration.inSeconds.toDouble())
            trArViewModelProvider.audioPlayer
                .seek(Duration(seconds: positions.round()));
        });
  }
}
