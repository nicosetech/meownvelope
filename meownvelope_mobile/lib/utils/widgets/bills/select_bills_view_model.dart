import 'package:flutter/foundation.dart';

class SelectBillsViewModel extends ChangeNotifier {
  final Map<String, int> _maxCounts;
  final Map<String, int> _counts;

  SelectBillsViewModel(this._maxCounts)
      : _counts = {for (var key in _maxCounts.keys) key: 0};

  int getCount(String label) => _counts[label] ?? 0;
  int getMax(String label) => _maxCounts[label] ?? 0;

  bool canIncrement(String label) => getCount(label) < getMax(label);
  bool canDecrement(String label) => getCount(label) > 0;

  void increment(String label) {
    if (canIncrement(label)) {
      _counts[label] = _counts[label]! + 1;
      notifyListeners();
    }
  }

  void decrement(String label) {
    if (canDecrement(label)) {
      _counts[label] = _counts[label]! - 1;
      notifyListeners();
    }
  }

  Map<String, int> get selectedCounts => Map.unmodifiable(_counts);
}