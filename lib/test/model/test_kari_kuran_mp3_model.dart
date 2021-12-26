// To parse this JSON data, do
//
//     final KariKuranMp3Model = KariKuranMp3ModelFromJson(jsonString);

import 'dart:convert';

KariKuranMp3Model KariKuranMp3ModelFromJson(String str) =>
    KariKuranMp3Model.fromJson(json.decode(str));

class KariKuranMp3Model {
  KariKuranMp3Model({
    this.reciters,
  });

  List<Reciter>? reciters;

  factory KariKuranMp3Model.fromJson(Map<String, dynamic> json) =>
      KariKuranMp3Model(
        reciters: List<Reciter>.from(
            json["reciters"].map((x) => Reciter.fromJson(x))),
      );
}

class Reciter {
  Reciter({
    this.id,
    this.name,
    this.server,
    this.rewaya,
    this.count,
    this.letter,
    this.suras,
  });

  String? id;
  String? name;
  String? server;
  String? rewaya;
  String? count;
  String? letter;
  String? suras;

  factory Reciter.fromJson(Map<String, dynamic> json) => Reciter(
        id: json["id"],
        name: json["name"],
        server: json["Server"],
        rewaya: json["rewaya"],
        count: json["count"],
        letter: json["letter"],
        suras: json["suras"],
      );
}
