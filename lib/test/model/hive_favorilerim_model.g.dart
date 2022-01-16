// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_favorilerim_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveFavorilerimModelAdapter extends TypeAdapter<HiveFavorilerimModel> {
  @override
  final int typeId = 0;

  @override
  HiveFavorilerimModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveFavorilerimModel(
      id: fields[3] as int?,
      arabicText: fields[0] as String?,
      turkishText: fields[1] as String?,
      latinText: fields[2] as String?,
      surahNo: fields[4] as int?,
      ayahNo: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveFavorilerimModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.arabicText)
      ..writeByte(1)
      ..write(obj.turkishText)
      ..writeByte(2)
      ..write(obj.latinText)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.surahNo)
      ..writeByte(5)
      ..write(obj.ayahNo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveFavorilerimModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
