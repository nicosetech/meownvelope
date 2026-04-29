import 'package:flutter_test/flutter_test.dart';
import 'package:meownvelope_mobile/pages/standalone_pages/envelope_creation_page/envelope_creation_view_model.dart';

void main() {
  group('EnvelopeCreationViewModel - validateAndCreate', () {
    late EnvelopeCreationViewModel viewModel;

    setUp(() {
      viewModel = EnvelopeCreationViewModel();
    });

    test('empty name returns error message', () async {
      final result = await viewModel.validateAndCreate('', '100');
      expect(result, isNotNull);
    });

    test('name over 20 characters returns error message', () async {
      final result = await viewModel.validateAndCreate('ThisNameIsSuperLongForAnyoneToEverCareAboutAndReadDr.LehrIfYoureSeeingThisHi', '100');
      expect(result, isNotNull);
    });

    test('empty goal returns error message', () async {
      final result = await viewModel.validateAndCreate('Savings', '');
      expect(result, isNotNull);
    });

    test('non-numeric goal returns error message', () async {
      final result = await viewModel.validateAndCreate('Savings', 'abc');
      expect(result, isNotNull);
    });

    test('goal of zero returns error message', () async {
      final result = await viewModel.validateAndCreate('Savings', '0');
      expect(result, isNotNull);
    });
  });
}