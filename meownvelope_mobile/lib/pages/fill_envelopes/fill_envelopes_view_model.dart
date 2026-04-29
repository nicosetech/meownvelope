import 'package:meownvelope_mobile/data/repositories/badge_repository.dart';
import 'package:meownvelope_mobile/data/repositories/envelope_repository.dart';
import 'package:meownvelope_mobile/data/repositories/streak_repository.dart';
import 'package:meownvelope_mobile/data/repositories/user_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';
import 'package:meownvelope_mobile/utils/widgets/bills/bill_view_model.dart';


class FillEnvelopesViewModel extends ChangeNotifier{
  FillEnvelopesViewModel(this._billViewModel) {init();}
  final BillViewModel _billViewModel;

  double _tempUserFunds = 0.0;
  double _piggyBankFunds = 0.0; 
  num _amountSavedToEnvsThisSession = 0;

  final Map<EnvelopeData, double> _tempBalances = {};
  final _envsDepositedTo = <EnvelopeData> []; 


  double get piggyBankFunds => _piggyBankFunds;
  double get userFunds => _tempUserFunds;

  void init() {
    _tempUserFunds = UserDataRepository.getUserData().get('balance', defaultValue: 0.0); 
    _piggyBankFunds = _billViewModel.fundsToBills(_tempUserFunds);
    _amountSavedToEnvsThisSession = 0;
    _tempBalances.clear();
    for (var env in getSortedEnvelopes()) {
      _tempBalances[env] = env.balance;
      }  
  }

  List<EnvelopeData> getSortedEnvelopes () {
    List<EnvelopeData> sortedEnvelopes = EnvelopeRepository.getEnvelopes().values.toList();
    sortedEnvelopes.sort((a, b) => a.displayOrder.compareTo(b.displayOrder)); 

    return sortedEnvelopes;
  }

  void onEnvelopeAccept(EnvelopeData envelope, double value) {
    if(!_envsDepositedTo.contains(envelope)) {
        _envsDepositedTo.add(envelope); 
    }

    _tempBalances[envelope] = (getEnvelopeBalance(envelope) + value);
    _amountSavedToEnvsThisSession += value;
    notifyListeners();
  }
  

  double getEnvelopeBalance(EnvelopeData envelope) {
    return _tempBalances[envelope] ?? envelope.balance;
  }

  Future<void> commitEnvelopes() async {
    for (var entry in _tempBalances.entries) {
      await EnvelopeRepository.addOrRemoveEnevelopeBalance(entry.key, entry.value - entry.key.balance);

      if (entry.key.balance >= entry.key.budgetTarget) { 
        await BadgeRepository.checkGoalBadges(); } 

    }
    // Store the daily count from the UserDataRepository
    final DateTime? lastDepositDate = UserDataRepository.getLastDailyDepositDate();
    final DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    // This is to reset the count if it's a new day
    int dailyCount = UserDataRepository.getDailyEnvelopeDepositCount();
    if (lastDepositDate == null || DateTime(lastDepositDate.year, lastDepositDate.month, lastDepositDate.day) != today) {
      dailyCount = 0;
    }

    dailyCount += _envsDepositedTo.length;

    await UserDataRepository.setDailyEnvelopeDepositCount(dailyCount);
    await UserDataRepository.setLastDailyDepositDate(DateTime.now());

    await BadgeRepository.checkDailyDepositBadges(dailyCount);
    await StreakRepository.updateSavingStreak(); 
    await StreakRepository.updateDepositDayStreak(); 
    await BadgeRepository.checkDepositBadges(_amountSavedToEnvsThisSession.toDouble()); 
    await UserDataRepository.getUserData().put('balance', _tempUserFunds - _amountSavedToEnvsThisSession);

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