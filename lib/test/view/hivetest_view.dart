import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
class HiveNoSql extends StatefulWidget {
  const HiveNoSql({ Key? key }) : super(key: key);

  @override
  _HiveNoSqlState createState() => _HiveNoSqlState();
}

class _HiveNoSqlState extends State<HiveNoSql> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    saveData();
  }

  Future<dynamic> saveData()async{
    await Hive.initFlutter();
     var box = await Hive.openBox('testBox');
      var box2=await Hive.openBox("test");
  print(box2.keys.length);
  //box2.delete("isim");
  print('Name: ${box.get('name')}');
  print('İsim ${box2.get('isim')}');
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