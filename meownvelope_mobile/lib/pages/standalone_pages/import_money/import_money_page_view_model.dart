import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/data/repositories/badge_repository.dart';
import 'package:meownvelope_mobile/data/repositories/transaction_repository.dart';
import 'package:meownvelope_mobile/data/repositories/user_data_repository.dart';

enum ImportMoneyState { idle, loading, success, error }

class ImportMoneyPageViewModel extends ChangeNotifier {
  final TextEditingController amountController = TextEditingController();

  ImportMoneyState _state = ImportMoneyState.idle;
  ImportMoneyState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  double? _importedAmount;
  double? get importedAmount => _importedAmount;

  Future<void> importFunds() async {
    final text = amountController.text.trim();

    if (text.isEmpty) {
      _errorMessage = 'Please enter an amount.';
      _state = ImportMoneyState.error;
      notifyListeners();
      return;
    }

    final double? amount = double.tryParse(text);
    if (amount == null) {
      _errorMessage = 'Please enter a valid number.';
      _state = ImportMoneyState.error;
      notifyListeners();
      return;
    }

    if (amount <= 0) {
      _errorMessage = 'Amount must be greater than \$0.';
      _state = ImportMoneyState.error;
      notifyListeners();
      return;
    }

    _state = ImportMoneyState.loading;
    notifyListeners();

    await UserDataRepository.importFunds(amount);
    await TransactionRepository.newTransaction(null, null, amount, 0);
    await BadgeRepository.checkImportBadges();

    _importedAmount = amount;
    _state = ImportMoneyState.success;
    notifyListeners();
  }

  void resetState() {
    _state = ImportMoneyState.idle;
    _errorMessage = null;
    _importedAmount = null;
    notifyListeners();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}