// To parse this JSON data, do
//
//     final FollowQuranModel = FollowQuranModelFromJson(jsonString);

import 'dart:convert';

import 'package:kuran/view/meal/model/singleayah_model.dart';

FollowQuranModel followQuranModelFromJson(String str) =>
    FollowQuranModel.fromJson(json.decode(str));

class FollowQuranModel {
  FollowQuranModel({
    this.data,
  });

  Data? data;

  factory FollowQuranModel.fromJson(Map<String, dynamic> json) =>
      FollowQuranModel(
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.number,
    this.ayahs,
    
  });

  int? number;
  List<Ayah>? ayahs;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        number: json["number"],
        ayahs: List<Ayah>.from(json["ayahs"].map((x) => Ayah.fromJson(x))),
      );
}

class Ayah {
  Ayah({
    this.number,
    this.audio,
    this.audioSecondary,
    this.text,
    this.surah,
    this.numberInSurah,
    this.juz,
    this.manzil,
    this.page,
    this.ruku,
    this.hizbQuarter,
    this.sajda,
  });

  int? number;
  String? audio;
  List<String>? audioSecondary;
  String? text;
  SurahDetail? surah;
  int? numberInSurah;
  int? juz;
  int? manzil;
  int? page;
  int? ruku;
  int? hizbQuarter;
  bool? sajda;

  factory Ayah.fromJson(Map<String, dynamic> json) => Ayah(
        number: json["number"],
        audio: json["audio"],
        audioSecondary: List<String>.from(json["audioSecondary"].map((x) => x)),
        text: json["text"],
        surah: SurahDetail.fromJson(json["surah"]),
        numberInSurah: json["numberInSurah"],
        juz: json["juz"],
        manzil: json["manzil"],
        page: json["page"],
        ruku: json["ruku"],
        hizbQuarter: json["hizbQuarter"],
        sajda: json["sajda"],
      );
}
class SurahDetail {
    SurahDetail({
        this.number,
        this.name,
        this.englishName,
        this.englishNameTranslation,
        this.revelationType,
        this.numberOfAyahs,
    });

    int? number;
    String? name;
    String? englishName;
    String? englishNameTranslation;
    String? revelationType;
    int? numberOfAyahs;

    factory SurahDetail.fromJson(Map<String, dynamic> json) => SurahDetail(
        number: json["number"],
        name: json["name"],
        englishName: json["englishName"],
        englishNameTranslation: json["englishNameTranslation"],
        revelationType: json["revelationType"],
        numberOfAyahs: json["numberOfAyahs"],
    );

    Map<String, dynamic> toJson() => {
        "number": number,
        "name": name,
        "englishName": englishName,
        "englishNameTranslation": englishNameTranslation,
        "revelationType": revelationType,
        "numberOfAyahs": numberOfAyahs,
    };
}

class Edition {
  Edition({
    this.identifier,
    this.language,
    this.name,
    this.englishName,
    this.format,
    this.type,
    this.direction,
  });

  String? identifier;
  String? language;
  String? name;
  String? englishName;
  String? format;
  String? type;
  dynamic direction;

  factory Edition.fromJson(Map<String, dynamic> json) => Edition(
        identifier: json["identifier"],
        language: json["language"],
        name: json["name"],
        englishName: json["englishName"],
        format: json["format"],
        type: json["type"],
        direction: json["direction"],
      );

  Map<String, dynamic> toJson() => {
        "identifier": identifier,
        "language": language,
        "name": name,
        "englishName": englishName,
        "format": format,
        "type": type,
        "direction": direction,
      };
}

