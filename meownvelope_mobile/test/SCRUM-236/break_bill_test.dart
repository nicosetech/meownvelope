import 'package:flutter_test/flutter_test.dart';
import 'package:meownvelope_mobile/utils/widgets/bills/bill_view_model.dart';

void main() {
  group('Break Bill', () {
    late BillViewModel billViewModel;

    setUp(() {
      billViewModel = BillViewModel();
    });

    test('1. breaking a \$100 removes one \$100 and adds two \$50 bills', () {
      billViewModel.fundsToBills(100);
      billViewModel.breakBill(100);
      expect(billViewModel.amountHund, equals(0));
      expect(billViewModel.amountFifty, equals(2));
    });

    test('2. breaking a \$50 removes one \$50 and adds two \$20 and one \$10', () {
      billViewModel.fundsToBills(50);
      billViewModel.breakBill(50);
      expect(billViewModel.amountFifty, equals(0));
      expect(billViewModel.amountTwenty, equals(2));
      expect(billViewModel.amountTen, equals(1));
    });

    test('3. breaking a \$20 removes one \$20 and adds two \$10 bills', () {
      billViewModel.fundsToBills(20);
      billViewModel.breakBill(20);
      expect(billViewModel.amountTwenty, equals(0));
      expect(billViewModel.amountTen, equals(2));
    });

    test('4. breaking a \$10 removes one \$10 and adds two \$5 bills', () {
      billViewModel.fundsToBills(10);
      billViewModel.breakBill(10);
      expect(billViewModel.amountTen, equals(0));
      expect(billViewModel.amountFive, equals(2));
    });

    test('5. breaking a \$5 removes one \$5 and adds five \$1 bills', () {
      billViewModel.fundsToBills(5);
      billViewModel.breakBill(5);
      expect(billViewModel.amountFive, equals(0));
      expect(billViewModel.amountOne, equals(5));
    });

    test('6. breaking a \$1 does nothing', () {
      billViewModel.fundsToBills(1);
      billViewModel.breakBill(1);
      expect(billViewModel.amountOne, equals(1));
    });
  });
}