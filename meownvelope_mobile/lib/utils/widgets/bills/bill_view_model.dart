import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/utils/widgets/bills/select_bills_view_model.dart';

class BillViewModel extends ChangeNotifier{
  int _amountHund = 0;
  int _amountFifty = 0;
  int _amountTwenty = 0;
  int _amountTen = 0;
  int _amountFive = 0;
  int _amountOne = 0;
  final Map<double, double> _pendingSums = {};


  int get amountHund => _amountHund;
  int get amountFifty => _amountFifty;
  int get amountTwenty => _amountTwenty;
  int get amountTen => _amountTen;
  int get amountFive => _amountFive;
  int get amountOne => _amountOne;
  double getPendingSum(double billValue) => _pendingSums[billValue] ?? billValue;


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

  void onBillDragged(double value) {
    if (value == 100.0) _amountHund -= 1;
    if (value == 50.0) _amountFifty -= 1;
    if (value == 20.0) _amountTwenty -= 1;
    if (value == 10.0) _amountTen -= 1;
    if (value == 5.0) _amountFive -= 1;
    if (value == 1.0) _amountOne -= 1;
    
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

  SelectBillsViewModel createSelectBillsViewModel() {
    return SelectBillsViewModel({
      "\$100": _amountHund,
      "\$50": _amountFifty,
      "\$20": _amountTwenty,
      "\$10": _amountTen,
      "\$5": _amountFive,
      "\$1": _amountOne,
    });
  }

  void selectMultipleBills(double sourceBillValue, Map<String, int> counts) {
    final billValues = {
      "\$1": 1.0,
      "\$5": 5.0,
      "\$10": 10.0,
      "\$20": 20.0,
      "\$50": 50.0,
      "\$100": 100.0,
    };

    double totalSum = sourceBillValue;
    for (var entry in counts.entries) {
      final value = billValues[entry.key]!;
      final count = entry.value;
      if (value == sourceBillValue) {
        final extraCount = count - 1;
        if (extraCount > 0) {
          totalSum += value * extraCount;
          switch (value.toInt()) {
            case 100: _amountHund -= extraCount; break;
            case 50: _amountFifty -= extraCount; break;
            case 20: _amountTwenty -= extraCount; break;
            case 10: _amountTen -= extraCount; break;
            case 5: _amountFive -= extraCount; break;
            case 1: _amountOne -= extraCount; break;
          }
        }
      } else {
        totalSum += value * count;
        switch (value.toInt()) {
          case 100: _amountHund -= count; break;
          case 50: _amountFifty -= count; break;
          case 20: _amountTwenty -= count; break;
          case 10: _amountTen -= count; break;
          case 5: _amountFive -= count; break;
          case 1: _amountOne -= count; break;
        }
      }
    }

    _pendingSums[sourceBillValue] = totalSum;
    notifyListeners();
  }

  void clearPendingSum(double billValue) {
    _pendingSums.remove(billValue);
  }
}