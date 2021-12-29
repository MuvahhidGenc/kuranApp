import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:kuran/globals/services/dio/request.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';

class NetworkManager extends ChangeNotifier {
  bool downloading = true;
  double progress = 0;
  double newProgress = 0;
  @override
  notifyListeners();

  Future downloadFile({required String url, required String fileName}) async {
    Dio dio = Dio();
    var dir = await getApplicationDocumentsDirectory();
    var path = "${dir.path}/$fileName";
    var pathState = File(path);
    if (!pathState.existsSync()) {
      await dio.download(url, path, onReceiveProgress: (rec, total) {
        // print("Rec:$rec,Total: $total test");
        downloading = true;
        progress = ((rec / total) * 100);
        notifyListeners();
        //print(progress);
        //print(dir.path+"/kuranuthmani.dpf");
      });

      downloading = false;
      notifyListeners();
    }

    return path;
  }

  /*Future<int?> download(String url, String folderandpath) async {
    Dio dio = Dio();

    var dir = await getApplicationDocumentsDirectory();
    var path = "${dir.path}/$folderandpath";
    if (!dir.existsSync()) {
      await dio.download(url, path, onReceiveProgress: (rec, total) {
        //print("Rec:$rec,Total: $total test");
        downloading = false;
        progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        // print("test2");
        //print(dir.path+"/kuranuthmani.dpf");
      });
    } else {
      return 2;
    }

    downloading = false;
    progressString = "İndirme İşlemi Tamamlamdı";
    return 1;
  }*/

  Future downloadMediaFile({String? url, String? folderandpath}) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$folderandpath');

    if (!file.existsSync()) {
      final bytes = await readBytes(Uri.parse(url!));
      await file.writeAsBytes(bytes);
    }
    return file.path;
  }

  Future saveStorage(
      {required String? url,
      required String? folder,
      required String? fileName}) async {
    Directory root = await getTemporaryDirectory(); // Root Getir
    String directoryPath =
        '${root.path}$folder'; // Kök Dizine Hafizlar Adlı Klasör Aç
    final test = await Directory(directoryPath)
        .create(recursive: true); // directory Oluştur

    File file = File(test.path + fileName!);
    if (file.existsSync()) {
      // Dosya Mevcutsa
      dynamic data = await file.readAsStringSync();
      return data;
    } else {
      // Değilse
      var getrespone = await GetPageAPI().getHttp(url!);
      var dataEncode = jsonEncode(getrespone);
      file.writeAsStringSync(dataEncode, flush: true, mode: FileMode.write);
      return dataEncode;
    }
  }
// Future saveStorage(String path, String url) async {
//     var dir = await getApplicationDocumentsDirectory();
//     File file = File(dir.path + path);
//     //  File file = File(dir.path + path);
//     if (file.existsSync()) {
//       // Dosya Mevcutsa
//       dynamic data = file.readAsStringSync();
//       return data;
//     } else {
//       // Değilse
//       var getrespone = await GetPageAPI().getHttp(url);
//       var dataEncode = jsonEncode(getrespone);
//       file.writeAsStringSync(dataEncode, flush: true, mode: FileMode.write);

//       return dataEncode;
//     }
//   }

//final tempDir = await getTemporaryDirectory();
  //       final downloadPath = tempDir.path + '/#downloaded.mp3';
}
