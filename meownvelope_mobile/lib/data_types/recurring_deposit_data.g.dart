// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_deposit_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecurringDepositDataAdapter extends TypeAdapter<RecurringDepositData> {
  @override
  final int typeId = 3;

  @override
  RecurringDepositData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecurringDepositData(
      label: fields[0] as String,
      amount: fields[1] as double,
      frequency: fields[2] as String,
      nextRunDate: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RecurringDepositData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.frequency)
      ..writeByte(3)
      ..write(obj.nextRunDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurringDepositDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
