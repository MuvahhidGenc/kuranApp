import 'package:flutter/material.dart';

class FollowQuranView extends StatefulWidget {
  const FollowQuranView({ Key? key }) : super(key: key);

  @override
  _FollowQuranViewState createState() => _FollowQuranViewState();
}

class _FollowQuranViewState extends State<FollowQuranView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: 604,
        itemBuilder:(context, index) {
          return Center(child: Text(index.toString()));
        },
      ),
    );
  }
}