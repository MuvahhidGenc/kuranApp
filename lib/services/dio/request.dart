import 'dart:convert';

import 'package:dio/dio.dart';

class GetPageAPI {
  Future<dynamic> getHttp(String url) async {
    var response = await Dio().get(url);
    //print(response);
    if (response.statusCode == 200) {
      return response.data;
    }
  }
}
