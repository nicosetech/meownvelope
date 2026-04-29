import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/data/repositories/user_data_repository.dart';
import 'package:meownvelope_mobile/data/services/api/api_tools.dart';
import 'package:meownvelope_mobile/data/services/api/credential_api.dart';
import 'package:meownvelope_mobile/pages/auth_pages/credential_form/credential_form_view_model.dart';

enum LoginState { idle, loading, success, error }

class LoginPageViewModel extends ChangeNotifier {
  final CredentialFormViewModel _credentialFormModel = CredentialFormViewModel(
    includeEmail: false,
  );
  CredentialFormViewModel get credentialFormModel => _credentialFormModel;

  LoginState _loginState = LoginState.idle;
  LoginState get loginState => _loginState;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void requestLogin() async {

    Map<String, String> textFields = _credentialFormModel.getInputFields();

    if (textFields.containsKey("username") &&
        textFields.containsKey("password")) {
      _loginState = LoginState.loading;
      notifyListeners();
      ApiReport createStatus = await CredentialApi.loginToAccount(
        textFields["username"]!,
        textFields["password"]!,
      );

      if (createStatus.result) {
        UserDataRepository.addLoginData(
          textFields["username"]!,
          textFields["password"]!,
        );
        _loginState = LoginState.success;
      } else {
        _loginState = LoginState.error;
        _errorMessage = createStatus.message;
      }
    }
    notifyListeners();
  }
}
