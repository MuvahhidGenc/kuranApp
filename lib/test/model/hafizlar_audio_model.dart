// To parse this JSON data, do
//
//     final hafizlar = hafizlarFromJson(jsonString);

import 'dart:convert';

Hafizlar hafizlarFromJson(String str) => Hafizlar.fromJson(json.decode(str));

class Hafizlar {
  Hafizlar({
    this.reciters,
  });

  List<Reciter>? reciters;

  factory Hafizlar.fromJson(Map<String, dynamic> json) => Hafizlar(
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
