import 'dart:convert';

VerseByVerseKariModel verseByVerseKariModelFromJson(String str) =>
    VerseByVerseKariModel.fromJson(json.decode(str));

class VerseByVerseKariModel {
  VerseByVerseKariModel({
    this.data,
  });

  final List<Datum>? data;

  factory VerseByVerseKariModel.fromJson(Map<String, dynamic> json) =>
      VerseByVerseKariModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  Datum({
    this.identifier,
    this.language,
    this.name,
    this.englishName,
    this.format,
    this.type,
    this.direction,
  });

  final String? identifier;
  final Language? language;
  final String? name;
  final String? englishName;
  final Format? format;
  final Type? type;
  final dynamic direction;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        identifier: json["identifier"],
        language: languageValues.map![json["language"]],
        name: json["name"],
        englishName: json["englishName"],
        format: formatValues.map![json["format"]],
        type: typeValues.map![json["type"]],
        direction: json["direction"],
      );
}

enum Format { AUDIO }

final formatValues = EnumValues({"audio": Format.AUDIO});

enum Language { AR }

final languageValues = EnumValues({"ar": Language.AR});

enum Type { VERSEBYVERSE }

final typeValues = EnumValues({"versebyverse": Type.VERSEBYVERSE});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
