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
      appBar: AppBar(title: Text("data"),),
      body: PageView.builder(
        itemCount: 604,
        itemBuilder:(context, index) {
          // ignore: avoid_unnecessary_containers
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(decoration: BoxDecoration(
              border: Border.all(color: Colors.black)
            ), child: Center(child: Text(index.toString()))),
          );
        },
      ),
    );
  }
}