// To parse this JSON data, do
//
//     final sureNameModel = sureNameModelFromJson(jsonString);

import 'dart:convert';

SureNameModel sureNameModelFromJson(String str) => SureNameModel.fromJson(json.decode(str));


class SureNameModel {
    SureNameModel({
        this.data,
    });

    List<Datum>? data;

    factory SureNameModel.fromJson(Map<String, dynamic> json) => SureNameModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

   
}

class Datum {
    Datum({
        this.id,
        this.name,
        this.slug,
        this.verseCount,
        this.pageNumber,
        this.nameOriginal,
        this.audio,
    });

    int? id;
    String? name;
    String? slug;
    int? verseCount;
    int? pageNumber;
    String? nameOriginal;
    Audio? audio;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        verseCount: json["verse_count"],
        pageNumber: json["pageNumber"],
        nameOriginal: json["name_original"],
        audio: Audio.fromJson(json["audio"]),
    );

    
}

class Audio {
    Audio({
        this.mp3,
        this.duration,
    });

    String? mp3;
    int? duration;

    factory Audio.fromJson(Map<String, dynamic> json) => Audio(
        mp3: json["mp3"],
        duration: json["duration"],
    );

    Map<String, dynamic> toJson() => {
        "mp3": mp3,
        "duration": duration,
    };
}
