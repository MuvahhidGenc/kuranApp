import 'package:hive/hive.dart';
import 'package:kuran/test/model/user_model.dart';

class HiveBoxes {
 static Box<User> getTransactions()=>Hive.box("users");
}