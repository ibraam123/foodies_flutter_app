// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_meal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteMealAdapter extends TypeAdapter<FavoriteMeal> {
  @override
  final int typeId = 0;

  @override
  FavoriteMeal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteMeal(
      id: fields[0] as String,
      name: fields[1] as String,
      imageUrl: fields[2] as String,
      category: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteMeal obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteMealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
