import 'package:hive/hive.dart';
import 'package:meownvelope_mobile/data_types/recurring_deposit_data.dart';

class RecurringDepositRepository {

  static Box<RecurringDepositData> getRecurringDeposits() {
    try {
      return Hive.box<RecurringDepositData>('recurringDeposits');
    } catch (e) {
      throw Exception('RecurringDeposits box not initialized');
    }
  }

  static Future<void> addRecurringDeposit(RecurringDepositData deposit) async {
    final box = getRecurringDeposits();
    await box.add(deposit);
  }

  static Future<void> deleteRecurringDeposit(RecurringDepositData deposit) async {
    await deposit.delete();
  }

  static List<RecurringDepositData> getAllRecurringDeposits() {
    final box = getRecurringDeposits();
    return box.values.toList();
  }
}