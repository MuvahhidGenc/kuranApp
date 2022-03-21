import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuran/globals/extantions/extanstion.dart';
import 'package:kuran/test/model/followquran_model.dart';
import 'package:kuran/test/view/followquran_view.dart';
import 'package:kuran/test/viewmodel/followquran_viewmodel.dart';

class CupertionPickerWidget extends StatelessWidget {
  final String name;
  final List<Widget> children;
  final BuildContext getContext;
  CupertionPickerWidget({
    required this.name,
    Key? key,
    required this.children,
    required this.getContext,
  }) : super(key: key);

  int selectedNumber = 1;
  var _followViewModel = FollowQuranViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SnippetExtanstion(context).theme.scaffoldBackgroundColor,
      height: MediaQuery.of(context).copyWith().size.height * 0.4,
      child: Column(
        children: [
          Expanded(
            child: CupertinoPicker(
              children: children,
              onSelectedItemChanged: (value) {
                selectedNumber = value + 1;
              },
              itemExtent: 25,
              diameterRatio: 1,
              useMagnifier: true,
              magnification: 1.3,
              looping: true,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _followViewModel.gotoPage(
                      _followViewModel.pageController, selectedNumber);
                },
                child: Text(name),
                // icon: Icon(Icons.arrow_right),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
