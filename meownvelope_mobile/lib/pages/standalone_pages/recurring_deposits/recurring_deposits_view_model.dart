import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/data/services/recurring_deposit_service.dart';

enum RecurringDepositState { idle, loading, success, error }

class RecurringDepositsViewModel extends ChangeNotifier {
  final TextEditingController labelController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String _selectedFrequency = 'Monthly';
  String get selectedFrequency => _selectedFrequency;

  RecurringDepositState _state = RecurringDepositState.idle;
  RecurringDepositState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final List<String> frequencies = ['Daily', 'Weekly', 'Bi-weekly', 'Monthly'];

  void setFrequency(String frequency) {
    _selectedFrequency = frequency;
    notifyListeners();
  }

  Future<void> saveDeposit() async {
    if (labelController.text.isEmpty || amountController.text.isEmpty) {
      _errorMessage = 'Please fill in all fields.';
      _state = RecurringDepositState.error;
      notifyListeners();
      return;
    }

    final double? amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      _errorMessage = 'Please enter a valid amount greater than \$0.';
      _state = RecurringDepositState.error;
      notifyListeners();
      return;
    }

    _state = RecurringDepositState.loading;
    notifyListeners();

    await RecurringDepositService.addRecurringDeposit(
      label: labelController.text,
      amount: amount,
      frequency: _selectedFrequency,
    );

    labelController.clear();
    amountController.clear();
    _selectedFrequency = 'Monthly';
    _state = RecurringDepositState.success;
    notifyListeners();
  }

  void resetState() {
    _state = RecurringDepositState.idle;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    labelController.dispose();
    amountController.dispose();
    super.dispose();
  }
}