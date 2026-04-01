import 'package:meownvelope_mobile/utils/hive/hive_database.dart';
import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';


class FillEnvelopesViewModel extends ChangeNotifier{
  double _tempUserFunds = 0.0;
  double _piggyBankFunds = 0.0; 
  int _amountHund = 0;
  int _amountFifty = 0;
  int _amountTwenty = 0;
  int _amountTen = 0;
  int _amountFive = 0;
  int _amountOne = 0;
  num _amountSavedToEnvsThisSession = 0;

  Map<EnvelopeData, double> _tempBalances = {};
  final _envsDepositedTo = <EnvelopeData> []; 


  double get piggyBankFunds => _piggyBankFunds;
  double get userFunds => _tempUserFunds;
  int get amountHund => _amountHund;
  int get amountFifty => _amountFifty;
  int get amountTwenty => _amountTwenty;
  int get amountTen => _amountTen;
  int get amountFive => _amountFive;
  int get amountOne => _amountOne;

  void init() {
    _tempUserFunds = HiveDatabase.getUserData().get('balance', defaultValue: 0.0); 
    _piggyBankFunds = fundsToBills(_tempUserFunds);
    _amountSavedToEnvsThisSession = 0;
    _tempBalances.clear();
    for (var env in getSortedEnvelopes()) {
      _tempBalances[env] = env.balance;
      }  
  }

  double fundsToBills(num total, {num? skipBill}) {
    final billNums = [100, 50, 20, 10, 5, 1];

    for (var bill in billNums) {
      if (bill == skipBill) {continue;}

      int count = total ~/ bill;
      total %= bill;

      switch(bill) {
        case 100: _amountHund += count; break;
        case 50: _amountFifty += count; break;
        case 20: _amountTwenty += count; break;
        case 10: _amountTen += count; break;
        case 5: _amountFive += count; break;
        case 1: _amountOne += count; break;
      }
    }

    return total.toDouble();
  }

  List<EnvelopeData> getSortedEnvelopes () {
    List<EnvelopeData> sortedEnvelopes = HiveDatabase.getEnvelopes().values.toList();
    sortedEnvelopes.sort((a, b) => a.displayOrder.compareTo(b.displayOrder)); 

    return sortedEnvelopes;
  }

  void onBillDragged(double value) {
    if (value == 100.0) _amountHund -= 1;
    if (value == 50.0) _amountFifty -= 1;
    if (value == 20.0) _amountTwenty -= 1;
    if (value == 10.0) _amountTen -= 1;
    if (value == 5.0) _amountFive -= 1;
    if (value == 1.0) _amountOne -= 1;

    notifyListeners();
  }

  void onEnvelopeAccept(EnvelopeData envelope, double value) {
    if(!_envsDepositedTo.contains(envelope)) {
        _envsDepositedTo.add(envelope); 
    }

    _tempBalances[envelope] = (getEnvelopeBalance(envelope) + value);
    _amountSavedToEnvsThisSession += value;
    notifyListeners();
  }

  void breakBill(num originalBillValue) {
    if(originalBillValue == 1) {return;}

    switch (originalBillValue.toInt()) {
    case 100: _amountHund -= 1; break;
    case 50:  _amountFifty -= 1; break;
    case 20:  _amountTwenty -= 1; break;
    case 10:  _amountTen -= 1; break;
    case 5:   _amountFive -= 1; break;
  }
  fundsToBills(originalBillValue, skipBill: originalBillValue);

  notifyListeners();
  }

  double getEnvelopeBalance(EnvelopeData envelope) {
    return _tempBalances[envelope] ?? envelope.balance;
  }

  Future<void> commitEnvelopes() async {
    for (var entry in _tempBalances.entries) {
      await HiveDatabase.addOrRemoveEnevelopeBalance(entry.key, entry.value - entry.key.balance);

      if (entry.key.balance >= entry.key.budgetTarget) { 
        await HiveDatabase.checkGoalBadges(); } 

    }
    await HiveDatabase.checkDailyDepsoitBadges(_envsDepositedTo.length);
    await HiveDatabase.updateSavingStreak(); 
    await HiveDatabase.updateDepositDayStreak(); 
    await HiveDatabase.checkDepositBadges(_amountSavedToEnvsThisSession.toDouble()); 
    await HiveDatabase.getUserData().put('balance', _tempUserFunds - _amountSavedToEnvsThisSession);

    _tempUserFunds -= _amountSavedToEnvsThisSession;
  }

  void revertEnvelopes() {
    _tempBalances.clear();
    _tempUserFunds = 0;
    _amountSavedToEnvsThisSession = 0;
    for (var env in getSortedEnvelopes()) {
      _tempBalances[env] = env.balance;
    }
    notifyListeners();
  }
  
}