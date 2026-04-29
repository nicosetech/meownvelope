import 'package:meownvelope_mobile/data/repositories/badge_repository.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';
import 'package:meownvelope_mobile/pages/envelope_details/money_control_view_model.dart'; 

class TransferControlsViewModel extends MoneyControlViewModel {
  TransferControlsViewModel(super.envelope);

  EnvelopeData? transferEnvelopeData;

  void handleEnvelopeSelect(EnvelopeData? val) {
    transferEnvelopeData = val;
    notifyListeners();
  }

  @override
  EnvelopeData? get destinationEnvelope => transferEnvelopeData;

  @override
  String? get destinationError => transferEnvelopeData == null ? 'no_envelope' : null;

  @override
  List<Future<void>> get additionalFutures => [BadgeRepository.checkTransferBadges()];
  
}