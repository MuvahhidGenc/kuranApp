import 'package:flutter/cupertino.dart';

class SureNameModel {
  String? name;
  int? surePage;
  String? orginalName;
  /*String? sureMp3;
  int? duration;*/

  SureNameModel(this.name, this.surePage, this.orginalName /*, this.sureMp3*/);

  SureNameModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    surePage = json["pageNumber"];
    orginalName = json["name_original"];
    /*sureMp3 = json["audio"]["mp3"];
    duration = json["audio"]["duration"];*/
  }
}
