import 'package:flutter/foundation.dart';
import 'package:meownvelope_mobile/data/repositories/user_data_repository.dart';
import 'package:meownvelope_mobile/data/services/api/api_tools.dart';
import 'package:meownvelope_mobile/data/services/api/envelope_update_api.dart';

class EnvelopeListViewModel extends ChangeNotifier {
  bool get isLoggedIn => UserDataRepository.isLoggedIn();

  Future<void> handleCodeSubmit(String code) async {
    ApiReport report = await EnvelopeUpdateApi.addUserToEnvelope(code);
    if (report.result) {
      notifyListeners();
    }
  }
}
