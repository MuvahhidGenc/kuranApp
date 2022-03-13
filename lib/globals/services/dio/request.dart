import 'package:dio/dio.dart';
import 'package:filesize/filesize.dart';
import 'package:http/http.dart' as http;

class GetPageAPI {
  Future<dynamic> getHttp(String url) async {
    var response = await Dio().get(url);
    //print(response);
    if (response.statusCode == 200) {
      return response.data;
    }
  }

  Future getFileSize(String url) async {
    http.Response r = await http.head(Uri.parse(url));
    var res = r.headers["content-length"];
    var size = filesize(res);
    return size;
  }
}
