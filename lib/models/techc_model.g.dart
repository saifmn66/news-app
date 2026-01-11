// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'techc_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TechCModelAdapter extends TypeAdapter<TechCModel> {
  @override
  final int typeId = 0;

  @override
  TechCModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TechCModel(
      id: fields[0] as int,
      title: fields[1] as String,
      link: fields[2] as String,
      author: fields[3] as String,
      date: fields[4] as String,
      imageUrl: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TechCModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.link)
      ..writeByte(3)
      ..write(obj.author)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TechCModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
