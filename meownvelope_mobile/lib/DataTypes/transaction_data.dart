import 'package:hive_flutter/adapters.dart';
import 'package:meownvelope_mobile/DataTypes/envelope_data.dart';

part 'transaction_data.g.dart';

@HiveType(typeId: 1)
class TransactionData extends HiveObject{
  @HiveField(0)
  final EnvelopeData? wEnvelope;

  @HiveField(1)
  final EnvelopeData? dEnvelope;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime timeStamp;

  @HiveField(4)
  final int? source;


  TransactionData({
    required this.wEnvelope,
    required this.dEnvelope,
    required this.amount,
    required this.timeStamp,
    required this.source,
  });

  @override
  String toString() {
    return "TransactionData(wEnvelope: $wEnvelope, dEnvelope: $dEnvelope, amount: $amount, timeStamp: $timeStamp, source: $source)";
  }

}