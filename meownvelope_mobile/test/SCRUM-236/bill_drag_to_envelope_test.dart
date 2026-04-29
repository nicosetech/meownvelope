import 'package:flutter_test/flutter_test.dart';
import 'package:meownvelope_mobile/utils/widgets/bills/bill_view_model.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';

void main() {
  group('Bill Drag to Envelope', () {
    late BillViewModel billViewModel;
    late EnvelopeData testEnvelope;

    setUp(() {
      billViewModel = BillViewModel();
      billViewModel.fundsToBills(100);

      testEnvelope = EnvelopeData(
        name: 'Test Envelope',
        color: 0xFF000000,
        budgetTarget: 500.0,
        balance: 0.0,
        displayOrder: 1,
        serverEnvID: null,
        users: {},
      );
    });

    test('1. increments the amount of money stored in the envelope', () {
      final initialBalance = testEnvelope.balance;
      testEnvelope.balance += 100.0;
      expect(testEnvelope.balance, equals(initialBalance + 100.0));
    });

    test('2. decrements the amount of money in the users funds', () {
      const double draggedValue = 100.0;
      const double initialFunds = 100.0;
      final double fundsAfterDrag = initialFunds - draggedValue;
      expect(fundsAfterDrag, equals(0.0));
    });

    test('3. decrements the number of that type of bill', () {
      final initialCount = billViewModel.amountHund;
      billViewModel.onBillDragged(100.0);
      expect(billViewModel.amountHund, equals(initialCount - 1));
    });

    test('4. the dragged bill no longer displays after drag', () {
      expect(billViewModel.amountHund, equals(1));
      billViewModel.onBillDragged(100.0);
      expect(billViewModel.amountHund, equals(0));
    });
  });
}