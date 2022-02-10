extension UrlPathExtanstion on URLAlQuranPath{
  String? get urlPath{
    switch (this) {
      case URLAlQuranPath.page:return "page/";
      case URLAlQuranPath.surah:return "surah/";
      case URLAlQuranPath.juz:return "juz/";
      case URLAlQuranPath.ayah:return "ayah/";
    }
  }
}

enum URLAlQuranPath{
 page,
 surah,
 juz,
 ayah,
}