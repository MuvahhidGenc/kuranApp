import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FilePathManager {
  Future<bool> getFilePathControl(String path) async {
    var dir = await getApplicationDocumentsDirectory();
    var file = File("${dir.path}/$path");
    return file.existsSync();
  }

  Future<String> getFilePath(String path) async {
    var dir = await getApplicationDocumentsDirectory();
    var file = File("${dir.path}/$path");
    if (file.existsSync()) {
      return file.path;
    } else {
      return "";
    }
  }

  Future<File> converToPath(String path) async {
    var dir = await getApplicationDocumentsDirectory();
    var file = File("${dir.path}/$path");
    return file;
  }
}
