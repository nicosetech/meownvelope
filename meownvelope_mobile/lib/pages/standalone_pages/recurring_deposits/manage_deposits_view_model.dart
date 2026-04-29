import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/data/services/recurring_deposit_service.dart';
import 'package:meownvelope_mobile/data_types/recurring_deposit_data.dart';

enum ManageDepositsState { idle, deleted, error }

class ManageDepositsViewModel extends ChangeNotifier {
  List<RecurringDepositData> _deposits = [];
  List<RecurringDepositData> get deposits => _deposits;

  ManageDepositsState _state = ManageDepositsState.idle;
  ManageDepositsState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ManageDepositsViewModel() {
    loadDeposits();
  }

  void loadDeposits() {
    _deposits = RecurringDepositService.getAllRecurringDeposits();
    notifyListeners();
  }

  Future<void> deleteDeposit(RecurringDepositData deposit) async {
    try {
      await RecurringDepositService.deleteRecurringDeposit(deposit);
      _state = ManageDepositsState.deleted;
      loadDeposits();
    } catch (e) {
      _errorMessage = 'Failed to delete deposit.';
      _state = ManageDepositsState.error;
      notifyListeners();
    }
  }

  void resetState() {
    _state = ManageDepositsState.idle;
    _errorMessage = null;
    notifyListeners();
  }
}