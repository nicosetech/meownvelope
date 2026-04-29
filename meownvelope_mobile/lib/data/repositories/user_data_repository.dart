import 'package:hive/hive.dart';
import 'package:meownvelope_mobile/data/repositories/envelope_repository.dart';
import 'package:meownvelope_mobile/data/services/api/websocket_client.dart';

class UserDataRepository {
  static Box getUserData() {
    try {
      return Hive.box("userData");
    } catch (e) {
      throw Exception("UserData box not initialized");
    }
  }

  static Future<void> addLoginData(String username, String password) async {
    final Box userData = getUserData();
    userData.put("username", username);
    userData.put("password", password);
    WebsocketClient.initializeWebsocket();
  }

  static Future<void> removeLoginData() async {
    final Box userData = getUserData();
    userData.delete("username");
    userData.delete("password");
    WebsocketClient.disconnectWebsocket();
    EnvelopeRepository.removeCloudEnvelopes();
  }

  static Future<void> importFunds(double amount) async {
    final userData = getUserData();
    final double current = userData.get('balance', defaultValue: 0.0);
    await userData.put('balance', current + amount);
  }

  static Future<String?> getUsername() async {
    final userData = getUserData();
    return userData.get('username');
  }

  static Future<String?> getPassword() async {
    final userData = getUserData();
    return userData.get('password');
  }

  static int getDailyEnvelopeDepositCount() => getUserData().get('dailyEnvelopeDepositCount', defaultValue: 0);
  static DateTime? getLastDailyDepositDate() => getUserData().get('lastDailyDepositDate');
  static Future<void> setDailyEnvelopeDepositCount(int count) async => await getUserData().put('dailyEnvelopeDepositCount', count);
  static Future<void> setLastDailyDepositDate(DateTime date) async => await getUserData().put('lastDailyDepositDate', date);

  static bool isLoggedIn() => getUserData().get("username") != null;
}