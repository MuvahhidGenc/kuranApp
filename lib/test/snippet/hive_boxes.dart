import 'package:hive/hive.dart';
import '../model/user_model.dart';

class HiveBoxes {
 static Box<User> getTransactions()=>Hive.box("users");
}