import 'package:flutter/foundation.dart';
import 'package:meownvelope_mobile/data/repositories/user_data_repository.dart';
import 'package:meownvelope_mobile/data/services/api/api_tools.dart';
import 'package:meownvelope_mobile/data/services/api/envelope_update_api.dart';
import 'package:meownvelope_mobile/data/services/api/websocket_client.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';
import 'package:meownvelope_mobile/data/repositories/envelope_repository.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';
import 'package:provider/provider.dart';

class EnvelopeDetailsViewModel extends ChangeNotifier {
  final EnvelopeData envelope;

  EnvelopeDetailsViewModel(this.envelope) {
    pendingName = envelope.name;
    pendingColor = envelope.color;
    WebsocketClient.addListener(updateDetailsPage);
  }

  late String pendingName;
  late int pendingColor;
  bool showTransferFields = false;
  bool showWithdrawalFields = false;
  late Function(dynamic) updateDetailsPage = (data) => notifyListeners();

  void toggleTransferFields() {
    showTransferFields = !showTransferFields;
    notifyListeners();
  }

  void toggleWithdrawalFields() {
    showWithdrawalFields = !showWithdrawalFields;
    notifyListeners();
  }

  void handleNameChange(String name) {
    pendingName = name;
    notifyListeners();
  }

  void handleColorChange(int color) {
    pendingColor = color;
    notifyListeners();
  }

  Future<void> handleSave() async {
    envelope.name = pendingName;
    envelope.color = pendingColor;
    await envelope.save();
  }

  Future<bool> handleDelete() async {
    return await EnvelopeRepository.deleteEnvelope(envelope);
  }

  CloudButtonState getCloudButtonState() {
    if (!UserDataRepository.isLoggedIn()) return CloudButtonState.locked;
    if (envelope.serverEnvID == null) return CloudButtonState.cloud;
    return CloudButtonState.uploaded;
  }

  void handleCloudButtonTap({
    required VoidCallback onLocked,
    required VoidCallback onCloud,
    required VoidCallback onUploaded,
  }) {
    final state = getCloudButtonState();
    if (state == CloudButtonState.locked)
      onLocked();
    else if (state == CloudButtonState.cloud)
      onCloud();
    else if (state == CloudButtonState.uploaded)
      onUploaded();
  }

  Future<void> handleCloudButtonPress() async {
    ApiReport report = await EnvelopeUpdateApi.addEnvelopeToServer(envelope);
    if (report.result == true) {
      notifyListeners();
    }
  }

  Future<String?> handleShareCodeButtonPress() async {
    ApiReport report = await EnvelopeUpdateApi.requestShareCode(
      envelope.serverEnvID!,
    );
    if (report.result == true) {
      return report.message;
    }
  }

  void onPop() {
    WebsocketClient.stopListening(updateDetailsPage);
  }
}

enum CloudButtonState {
  locked, // User is NOT logged in so show lock
  cloud, // User is logged in and Envelope is local ONLY
  uploaded, // User is logged in and Envelope is on Server
}

// Shows the three possible states of the cloud/share button.
// Will be used by EnvelopeDetailsViewModel to determine which Icons to display and what action to take when they are pressed.
