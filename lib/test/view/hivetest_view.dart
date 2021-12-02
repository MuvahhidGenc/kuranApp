import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveNoSql extends StatefulWidget {
  const HiveNoSql({Key? key}) : super(key: key);

  @override
  _HiveNoSqlState createState() => _HiveNoSqlState();
}

class _HiveNoSqlState extends State<HiveNoSql> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
    );
  }
}
