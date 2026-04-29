import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/data/services/api/api_tools.dart';
import 'package:meownvelope_mobile/data/services/api/credential_api.dart';
import 'package:meownvelope_mobile/pages/auth_pages/credential_form/credential_form_view_model.dart';

enum CreateAccountState { idle, loading, success, error }

class CreateAccountPageViewModel extends ChangeNotifier {

  CredentialFormViewModel _credentialFormModel = CredentialFormViewModel();
  CredentialFormViewModel get credentialFormModel => _credentialFormModel;

  CreateAccountState _createAccountState = CreateAccountState.idle;
  CreateAccountState get createAccountState => _createAccountState;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void requestAccount() async {
    Map<String, String> textFields = _credentialFormModel.getInputFields();
    if (textFields.containsKey("username") &&
        textFields.containsKey("email") &&
        textFields.containsKey("password")) {
      _createAccountState = CreateAccountState.loading;
      notifyListeners();
      ApiReport createStatus = await CredentialApi.createAccount(
        textFields["username"]!,
        textFields["email"]!,
        textFields["password"]!,
      );
      if (createStatus.result){
        _createAccountState = CreateAccountState.success;
      } else {
        _createAccountState = CreateAccountState.error;
        _errorMessage = createStatus.message;
      }
      notifyListeners();
    }
  }
}