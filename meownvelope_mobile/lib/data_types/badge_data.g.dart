// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BadgeDataAdapter extends TypeAdapter<BadgeData> {
  @override
  final int typeId = 2;

  @override
  BadgeData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BadgeData(
      name: fields[0] as String,
      description: fields[1] as String,
      isUnlocked: fields[2] as bool,
      dateEarned: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, BadgeData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.isUnlocked)
      ..writeByte(3)
      ..write(obj.dateEarned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
