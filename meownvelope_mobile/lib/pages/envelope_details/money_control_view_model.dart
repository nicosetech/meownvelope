import 'package:flutter/foundation.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';
import 'package:meownvelope_mobile/data/repositories/transaction_repository.dart';

abstract class MoneyControlViewModel extends ChangeNotifier {
  final EnvelopeData envelope;
  MoneyControlViewModel(this.envelope);

  EnvelopeData? get destinationEnvelope => null;
  String? get destinationError => null;
  List<Future<void>> get additionalFutures => [];

  Future<String?> validateAndTransfer(String amountText) async {
    final amount = double.tryParse(amountText);
    if (amount == null) return 'invalid_amount';
    if (destinationError != null) return destinationError;
    if (envelope.balance - amount < 0) return 'insufficient_funds';

    await Future.wait([
      TransactionRepository.transactionWithEdit(envelope, destinationEnvelope, amount, null),
      Future.delayed(Duration(milliseconds: 200)),
      ...additionalFutures,
    ]);

    return null;
  }
}