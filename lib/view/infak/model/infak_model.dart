// To parse this JSON data, do
//
//     final infakModel = infakModelFromJson(jsonString);

import 'dart:convert';

InfakModel infakModelFromJson(String str) =>
    InfakModel.fromJson(json.decode(str));

class InfakModel {
  InfakModel({
    this.data,
  });

  List<InfakModelData>? data;

  factory InfakModel.fromJson(Map<String, dynamic> json) => InfakModel(
        data: List<InfakModelData>.from(
            json["data"].map((x) => InfakModelData.fromJson(x))),
      );
}

class InfakModelData {
  InfakModelData({
    this.id,
    this.valilikizin,
    this.isim,
    this.baslik,
    this.aciklama,
    this.bankaisim,
    this.hesapadi,
    this.ibantl,
    this.ibanusd,
    this.ibaneuro,
    this.bickodu,
    this.delilgorsel,
  });

  int? id;
  String? valilikizin;
  String? isim;
  String? baslik;
  String? aciklama;
  String? bankaisim;
  String? hesapadi;
  String? ibantl;
  String? ibanusd;
  String? ibaneuro;
  String? bickodu;
  List<String>? delilgorsel;

  factory InfakModelData.fromJson(Map<String, dynamic> json) => InfakModelData(
        id: json["id"],
        valilikizin: json["valilikizin"],
        isim: json["isim"],
        baslik: json["baslik"],
        aciklama: json["aciklama"],
        bankaisim: json["bankaisim"],
        hesapadi: json["hesapadi"],
        ibantl: json["ibantl"],
        ibanusd: json["ibanusd"],
        ibaneuro: json["ibaneuro"],
        bickodu: json["bickodu"],
        delilgorsel: List<String>.from(json["delilgorsel"].map((x) => x)),
      );
}
