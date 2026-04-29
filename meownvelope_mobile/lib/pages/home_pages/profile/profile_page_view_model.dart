import 'package:flutter/foundation.dart';
import 'package:meownvelope_mobile/data/repositories/user_data_repository.dart';
import 'package:meownvelope_mobile/data/services/api/api_tools.dart';
import 'package:meownvelope_mobile/data/services/api/credential_api.dart';

class ProfilePageViewModel extends ChangeNotifier {
  bool isLoggedIn = false;
  String username = 'user_name';
  int selectedAvatarIndex = -1;

  void loadUserData() {
    isLoggedIn = UserDataRepository.isLoggedIn();
    if (isLoggedIn) {
      username = UserDataRepository.getUserData().get("username");
      selectedAvatarIndex = UserDataRepository.getUserData().get("avatarIndex", defaultValue: -1);
    }
    notifyListeners();
  }

  Future<void> handleLogout() async {
    await UserDataRepository.removeLoginData();
    isLoggedIn = false;
    notifyListeners();
  }

  Future<ApiReport> handleChangeUsername(String newUsername) async {
    final currentUsername = UserDataRepository.getUserData().get("username");
    final currentPassword = UserDataRepository.getUserData().get("password");
    ApiReport result = await CredentialApi.changeUsername(currentUsername, currentPassword, newUsername);
    if (result.result) {
        await UserDataRepository.getUserData().put("username", newUsername);
        username = newUsername;
    }
    notifyListeners();
    return result;
  }

  Future<ApiReport> handleChangePassword(String newPassword) async {
    final username = UserDataRepository.getUserData().get("username");
    final password = UserDataRepository.getUserData().get("password");
    ApiReport result = await CredentialApi.changePassword(username, password, newPassword);
    if (result.result) {
        await UserDataRepository.getUserData().put("password", newPassword);
    }
    notifyListeners();
    return result;
  }

  Future<void> handleDeleteAccount() async {
    final username = UserDataRepository.getUserData().get("username");
    final password = UserDataRepository.getUserData().get("password");
    ApiReport result = await CredentialApi.deleteAccount(username, password);
    if (result.result) {
        await UserDataRepository.getUserData().delete("username");
        await UserDataRepository.getUserData().delete("password");
        isLoggedIn = false;
    }
    notifyListeners();
  }

  Future<void> handleAvatarChange(int index) async {
    await UserDataRepository.getUserData().put("avatarIndex", index);
    selectedAvatarIndex = index;
    notifyListeners();
  }

  void handleLoginSuccess() {
    loadUserData();
  }
}