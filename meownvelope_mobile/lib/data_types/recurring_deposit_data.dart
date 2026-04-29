import 'package:hive_flutter/adapters.dart';
part 'recurring_deposit_data.g.dart';

@HiveType(typeId: 3)
class RecurringDepositData extends HiveObject {
  @HiveField(0)
  String label;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String frequency; // 'Daily', 'Weekly', 'Bi-weekly', 'Monthly'

  @HiveField(3)
  DateTime nextRunDate;

  RecurringDepositData({
    required this.label,
    required this.amount,
    required this.frequency,
    required this.nextRunDate,
  });

  @override
  String toString() {
    return 'RecurringDepositData(label: $label, amount: $amount, frequency: $frequency, nextRunDate: $nextRunDate)';
  }
}