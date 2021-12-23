import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FilePathManager {
  Future<bool> getFilePathControl(String path) async {
    var dir = await getApplicationDocumentsDirectory();
    var file = File("${dir.path}/$path");
    return file.existsSync();
  }
}
