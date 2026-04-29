import 'package:flutter_test/flutter_test.dart';
import 'package:meownvelope_mobile/pages/standalone_pages/recurring_deposits/recurring_deposits_view_model.dart';

void main() {
  late RecurringDepositsViewModel viewModel;

  setUp(() {
    viewModel = RecurringDepositsViewModel();
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('RecurringDepositsViewModel - saveDeposit', () {
    test('empty fields sets error state, errorMessage, and leaves selectedFrequency unchanged', () async {
      viewModel.labelController.text = '';
      viewModel.amountController.text = '';
      await viewModel.saveDeposit();
      expect(viewModel.state, RecurringDepositState.error);
      expect(viewModel.errorMessage, 'Please fill in all fields.');
      expect(viewModel.selectedFrequency, 'Monthly');
    });

    test('label filled but empty amount sets error state, errorMessage, and leaves selectedFrequency unchanged', () async {
      viewModel.labelController.text = 'Paycheck';
      viewModel.amountController.text = '';
      await viewModel.saveDeposit();
      expect(viewModel.state, RecurringDepositState.error);
      expect(viewModel.errorMessage, 'Please fill in all fields.');
      expect(viewModel.selectedFrequency, 'Monthly');
    });

    test('amount filled but empty label sets error state, errorMessage, and leaves selectedFrequency unchanged', () async {
      viewModel.labelController.text = '';
      viewModel.amountController.text = '100';
      await viewModel.saveDeposit();
      expect(viewModel.state, RecurringDepositState.error);
      expect(viewModel.errorMessage, 'Please fill in all fields.');
      expect(viewModel.selectedFrequency, 'Monthly');
    });

    test('non-numeric amount sets error state, errorMessage, and leaves selectedFrequency unchanged', () async {
      viewModel.labelController.text = 'Paycheck';
      viewModel.amountController.text = 'abc';
      await viewModel.saveDeposit();
      expect(viewModel.state, RecurringDepositState.error);
      expect(viewModel.errorMessage, 'Please enter a valid amount greater than \$0.');
      expect(viewModel.selectedFrequency, 'Monthly');
    });

    test('zero amount sets error state, errorMessage, and leaves selectedFrequency unchanged', () async {
      viewModel.labelController.text = 'Paycheck';
      viewModel.amountController.text = '0';
      await viewModel.saveDeposit();
      expect(viewModel.state, RecurringDepositState.error);
      expect(viewModel.errorMessage, 'Please enter a valid amount greater than \$0.');
      expect(viewModel.selectedFrequency, 'Monthly');
    });
  });

  group('RecurringDepositsViewModel - resetState', () {
    test('resets state and errorMessage back to defaults', () async {
      viewModel.labelController.text = '';
      viewModel.amountController.text = '';
      await viewModel.saveDeposit();
      viewModel.resetState();
      expect(viewModel.state, RecurringDepositState.idle);
      expect(viewModel.errorMessage, null);
      expect(viewModel.selectedFrequency, 'Monthly');
    });
  });
}