import 'package:flutter_test/flutter_test.dart';
import 'package:meownvelope_mobile/utils/widgets/bills/bill_view_model.dart';

void main() {
  group('User Funds Displayed as Bills', () {
    late BillViewModel billViewModel;

    setUp(() {
      billViewModel = BillViewModel();
    });

    test('1. \$100 produces one \$100 bill', () {
      billViewModel.fundsToBills(100);
      expect(billViewModel.amountHund, equals(1));
      expect(billViewModel.amountFifty, equals(0));
      expect(billViewModel.amountTwenty, equals(0));
      expect(billViewModel.amountTen, equals(0));
      expect(billViewModel.amountFive, equals(0));
      expect(billViewModel.amountOne, equals(0));
    });

    test('2. \$175 produces one \$100, one \$50, one \$20, and one \$5 bill', () {
      billViewModel.fundsToBills(175);
      expect(billViewModel.amountHund, equals(1));
      expect(billViewModel.amountFifty, equals(1));
      expect(billViewModel.amountTwenty, equals(1));
      expect(billViewModel.amountTen, equals(0));
      expect(billViewModel.amountFive, equals(1));
      expect(billViewModel.amountOne, equals(0));
    });

    test('3. \$1 produces one \$1 bill', () {
      billViewModel.fundsToBills(1);
      expect(billViewModel.amountHund, equals(0));
      expect(billViewModel.amountFifty, equals(0));
      expect(billViewModel.amountTwenty, equals(0));
      expect(billViewModel.amountTen, equals(0));
      expect(billViewModel.amountFive, equals(0));
      expect(billViewModel.amountOne, equals(1));
    });

    test('4. \$0 produces no bills', () {
      billViewModel.fundsToBills(0);
      expect(billViewModel.amountHund, equals(0));
      expect(billViewModel.amountFifty, equals(0));
      expect(billViewModel.amountTwenty, equals(0));
      expect(billViewModel.amountTen, equals(0));
      expect(billViewModel.amountFive, equals(0));
      expect(billViewModel.amountOne, equals(0));
    });

    test('5. \$286 produces two \$100, one \$50, one \$20, one \$10, one \$5, one \$1', () {
      billViewModel.fundsToBills(286);
      expect(billViewModel.amountHund, equals(2));
      expect(billViewModel.amountFifty, equals(1));
      expect(billViewModel.amountTwenty, equals(1));
      expect(billViewModel.amountTen, equals(1));
      expect(billViewModel.amountFive, equals(1));
      expect(billViewModel.amountOne, equals(1));
    });
  });
}