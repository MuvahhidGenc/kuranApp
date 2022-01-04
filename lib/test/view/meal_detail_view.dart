import 'package:flutter/material.dart';

class MealDetailView extends StatefulWidget {
  int id;
  MealDetailView(this.id, {Key? key}) : super(key: key);

  @override
  _MealDetailViewState createState() => _MealDetailViewState();
}

class _MealDetailViewState extends State<MealDetailView> {
  @override
  void initState() {
    // TODO: implement initState
    print(widget.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Sayfası"),
      ),
    );
  }
}
