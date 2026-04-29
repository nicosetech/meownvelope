import 'package:flutter_test/flutter_test.dart';
import 'package:meownvelope_mobile/pages/standalone_pages/import_money/import_money_page_view_model.dart';

void main() {
  late ImportMoneyPageViewModel viewModel;

  setUp(() {
    viewModel = ImportMoneyPageViewModel();
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('ImportMoneyPageViewModel - importFunds', () {
    test('empty input sets error state, errorMessage, and leaves importedAmount null', () async {
      viewModel.amountController.text = '';
      await viewModel.importFunds();
      expect(viewModel.state, ImportMoneyState.error);
      expect(viewModel.errorMessage, 'Please enter an amount.');
      expect(viewModel.importedAmount, null);
    });

    test('non-numeric input sets error state, errorMessage, and leaves importedAmount null', () async {
      viewModel.amountController.text = 'abc';
      await viewModel.importFunds();
      expect(viewModel.state, ImportMoneyState.error);
      expect(viewModel.errorMessage, 'Please enter a valid number.');
      expect(viewModel.importedAmount, null);
    });
  });

  group('ImportMoneyPageViewModel - resetState', () {
    test('resets state, errorMessage, and importedAmount back to defaults', () async {
      viewModel.amountController.text = '';
      await viewModel.importFunds();
      viewModel.resetState();
      expect(viewModel.state, ImportMoneyState.idle);
      expect(viewModel.errorMessage, null);
      expect(viewModel.importedAmount, null);
    });
  });
}
