import 'package:meownvelope_mobile/data/repositories/recurring_deposit_repository.dart';
import 'package:meownvelope_mobile/data/repositories/user_data_repository.dart';
import 'package:meownvelope_mobile/data_types/recurring_deposit_data.dart';

class RecurringDepositService {

  static int _missedDeposits(RecurringDepositData deposit) {
    final now = DateTime.now();
    if (now.isBefore(deposit.nextRunDate)) return 0;

    final difference = now.difference(deposit.nextRunDate).inDays;

    switch (deposit.frequency) {
      case 'Daily':     return difference + 1;
      case 'Weekly':    return (difference / 7).floor() + 1;
      case 'Bi-weekly': return (difference / 14).floor() + 1;
      case 'Monthly':   return (difference / 30).floor() + 1;
      default:          return 0;
    }
  }

  static DateTime _nextRunDate(String frequency) {
    final now = DateTime.now();
    switch (frequency) {
      case 'Daily':     return now.add(const Duration(days: 1));
      case 'Weekly':    return now.add(const Duration(days: 7));
      case 'Bi-weekly': return now.add(const Duration(days: 14));
      case 'Monthly':   return now.add(const Duration(days: 30));
      default:          return now.add(const Duration(days: 1));
    }
  }

  static Future<void> addRecurringDeposit({
    required String label,
    required double amount,
    required String frequency,
  }) async {
    final deposit = RecurringDepositData(
      label: label,
      amount: amount,
      frequency: frequency,
      nextRunDate: _nextRunDate(frequency),
    );
    await RecurringDepositRepository.addRecurringDeposit(deposit);
  }

  static Future<void> deleteRecurringDeposit(RecurringDepositData deposit) async {
    await RecurringDepositRepository.deleteRecurringDeposit(deposit);
  }

  static Future<void> processRecurringDeposits() async {
    final deposits = RecurringDepositRepository.getAllRecurringDeposits();

    for (final deposit in deposits) {
      final missed = _missedDeposits(deposit);
      if (missed > 0) {
        final totalAmount = deposit.amount * missed;
        await UserDataRepository.importFunds(totalAmount);
        deposit.nextRunDate = _nextRunDate(deposit.frequency);
        await deposit.save();
      }
    }
  }

  static List<RecurringDepositData> getAllRecurringDeposits() {
    return RecurringDepositRepository.getAllRecurringDeposits();
  }
}