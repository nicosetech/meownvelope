import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';
import 'package:meownvelope_mobile/pages/envelope_details/envelope_details_view_model.dart';

void main() {
  late EnvelopeData testEnvelope;

  setUp(() async {
    await setUpTestHive();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(EnvelopeDataAdapter());
    }
    await Hive.openBox<EnvelopeData>("envelopes");

    testEnvelope = EnvelopeData(  
      name: 'Test Envelope',
      color: 0xFFFF0000,
      budgetTarget: 100,
      balance: 67,
      displayOrder: 1,
      serverEnvID: null,
      users: {},
    );
  });

  tearDown(() async {
    await tearDownTestHive();
  });


  group('EnvelopeDetailsViewModel - initial state', () {
    test('pendingName initializes fom envelope name', () {
      final viewModel = EnvelopeDetailsViewModel(testEnvelope);
      expect(viewModel.pendingName, 'Test Envelope');
    });

    test('pendingColor initializes fom envelope color', () {
      final viewModel = EnvelopeDetailsViewModel(testEnvelope);
      expect(viewModel.pendingColor, 0xFFFF0000);
    });

    test('showTransferFields defaults to false', () {
      final viewModel = EnvelopeDetailsViewModel(testEnvelope);
      expect(viewModel.showTransferFields, false);
    });
  });

  group('envelopeDetailsViewModel - toggleTransferFields', () {
    test('sets showTransferFields to true on first call', () {
      final viewModel = EnvelopeDetailsViewModel(testEnvelope);
      viewModel.toggleTransferFields();
      expect(viewModel.showTransferFields, true);
    });

    test('sets showTransferFields back to false on second call', () {
      final viewModel = EnvelopeDetailsViewModel(testEnvelope);
      viewModel.toggleTransferFields();
      viewModel.toggleTransferFields();
      expect(viewModel.showTransferFields, false);
    });

    group('EnvelopedetailsViewModel - handleNameChange', () {
      test('updates pendingName correctly', () {
        final viewModel = EnvelopeDetailsViewModel(testEnvelope);
        viewModel.handleNameChange('New Name');
        expect(viewModel.pendingName, 'New Name');
      });

      test('updates pendingName correctly', () {
        final viewModel = EnvelopeDetailsViewModel(testEnvelope);
        viewModel.handleNameChange('New Name');
        expect(viewModel.pendingName, 'New Name');
      });
    });

    group('EnvelopeDetailsViewModel - handleColorChange', () {
      test('updates pendingColor correctly', () {
        final viewModel = EnvelopeDetailsViewModel(testEnvelope);
        viewModel.handleColorChange(0xFFFF0001);
        expect(viewModel.pendingColor, 0xFFFF0001);
      });
    });
  });
}