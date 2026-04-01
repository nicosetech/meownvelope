// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionDataAdapter extends TypeAdapter<TransactionData> {
  @override
  final int typeId = 1;

  @override
  TransactionData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionData(
      wEnvelope: fields[0] as EnvelopeData?,
      dEnvelope: fields[1] as EnvelopeData?,
      amount: fields[2] as double,
      timeStamp: fields[3] as DateTime,
      source: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.wEnvelope)
      ..writeByte(1)
      ..write(obj.dEnvelope)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.timeStamp)
      ..writeByte(4)
      ..write(obj.source);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
