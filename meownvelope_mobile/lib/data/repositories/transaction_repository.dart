import 'package:hive/hive.dart';
import 'package:meownvelope_mobile/data/repositories/envelope_repository.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';
import 'package:meownvelope_mobile/data_types/transaction_data.dart';

class TransactionRepository{
  static Box<TransactionData> getTransactions() {
    try {
      return Hive.box<TransactionData>("transactions");
    } catch (e) {
      throw Exception("Transactions box not initialized");
    }
  }

  static Future<void> newTransaction(
    EnvelopeData? wEnvelopeId,
    EnvelopeData? dEnvelopeId,
    double amount,
    int? source,
  ) async {
    Box? transactions = getTransactions();
    transactions.add(
      TransactionData(
        wEnvelope: wEnvelopeId,
        dEnvelope: dEnvelopeId,
        amount: amount,
        timeStamp: DateTime.now(),
        source: source,
      ),
    );
  }

  static Future<void> transactionWithEdit(
    EnvelopeData? wEnvelopeId,
    EnvelopeData? dEnvelopeId,
    double amount,
    int? source,
  ) async {
    await Future.wait([
      if (wEnvelopeId != null) EnvelopeRepository.addOrRemoveEnevelopeBalance(wEnvelopeId, -amount),
      if (dEnvelopeId != null) EnvelopeRepository.addOrRemoveEnevelopeBalance(dEnvelopeId, amount),
      newTransaction(wEnvelopeId, dEnvelopeId, amount, source)
    ]);
  }
}