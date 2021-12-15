import 'package:hive/hive.dart';
import 'package:kuran/view/kuran/modelview/hiveboxes.dart';

class HiveDb {
  Box? box;

  Future openBox(String boxName)async{
     return await Hive.openBox(boxName); // Open kuranPage DB
  }

  Future getBox(String boxName)async{
    box=await openBox(boxName);
    
   return box!.get(boxName);
  }

  Future putBox(String boxName,dynamic data)async{
    box=await openBox(boxName);
    
    await box!.put(boxName, data);
  }
  
  
}