// To parse this JSON data, do
//
//     final meal = mealFromJson(jsonString);

import 'dart:convert';

Meal mealFromJson(String str) => Meal.fromJson(json.decode(str));

class Meal {
  Meal({
    this.data,
  });

  final Data? data;

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.id,
    this.name,
    this.slug,
    this.verseCount,
    this.pageNumber,
    this.audio,
    this.verses,
  });

  final int? id;
  final String? name;
  final String? slug;
  final int? verseCount;
  final int? pageNumber;
  final Audio? audio;
  final List<Verse>? verses;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        verseCount: json["verse_count"],
        pageNumber: json["pageNumber"],
        audio: Audio.fromJson(json["audio"]),
        verses: List<Verse>.from(json["verses"].map((x) => Verse.fromJson(x))),
      );
}

class Audio {
  Audio({
    this.mp3,
    this.duration,
  });

  final String? mp3;
  final int? duration;

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
        mp3: json["mp3"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "mp3": mp3,
        "duration": duration,
      };
}

class Verse {
  Verse({
    this.id,
    this.surahId,
    this.verseNumber,
    this.verse,
    this.page,
    this.juzNumber,
    this.transcription,
    this.translation,
  });

  final int? id;
  final int? surahId;
  final int? verseNumber;
  final String? verse;
  final int? page;
  final int? juzNumber;
  final String? transcription;
  final Translation? translation;

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
        id: json["id"],
        surahId: json["surah_id"],
        verseNumber: json["verse_number"],
        verse: json["verse"],
        page: json["page"],
        juzNumber: json["juzNumber"],
        transcription: json["transcription"],
        translation: Translation.fromJson(json["translation"]),
      );
}

class Translation {
  Translation({
    this.id,
    this.author,
    this.text,
    this.footnotes,
  });

  final int? id;
  final Author? author;
  final String? text;
  final dynamic footnotes;

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
        id: json["id"],
        author: Author.fromJson(json["author"]),
        text: json["text"],
        footnotes: json["footnotes"],
      );
}

class Author {
  Author({
    this.id,
    this.name,
    this.description,
    this.language,
  });

  final int? id;
  final String? name;
  final String? description;
  final String? language;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        language: json["language"],
      );
}
