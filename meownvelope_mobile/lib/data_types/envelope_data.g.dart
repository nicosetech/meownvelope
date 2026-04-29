// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'envelope_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnvelopeDataAdapter extends TypeAdapter<EnvelopeData> {
  @override
  final int typeId = 0;

  @override
  EnvelopeData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnvelopeData(
      name: fields[0] as String,
      color: fields[1] as int,
      budgetTarget: fields[3] as double,
      balance: fields[4] as double,
      displayOrder: fields[5] as int,
      serverEnvID: fields[2] as String?,
      users: (fields[6] as Map).cast<int, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, EnvelopeData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.serverEnvID)
      ..writeByte(3)
      ..write(obj.budgetTarget)
      ..writeByte(4)
      ..write(obj.balance)
      ..writeByte(5)
      ..write(obj.displayOrder)
      ..writeByte(6)
      ..write(obj.users);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnvelopeDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
