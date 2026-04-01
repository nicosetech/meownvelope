import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CredentialApi {
  static final String ip = "szafall-gw.asuscomm.com:1240";

  static Future<ApiReport> createAccount(
    String username,
    String email,
    String password,
  ) async {
    try {
      var url = Uri.https(ip, '/api/createAccount');
      var response = await http
          .post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'username': username,
              'email': email,
              'password': password,
            }),
          )
          .timeout(Duration(seconds: 10));
      Map body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return ApiReport(true, "Account created!");
      } else if (body["message"] == "Username taken") {
        return ApiReport(false, "That username is taken! Try another.");
      } else if (body["message"] == "Email already used") {
        return ApiReport(
          false,
          "That email address is already taken. Try to login?",
        );
      }
    } on TimeoutException catch (_) {
      return ApiReport(
        false,
        "Cannot communicate with server... Try again later",
      );
    }
    return ApiReport(false, "An uncaught error occured.");
  }

  static Future<ApiReport> loginToAccount(
    String username,
    String password,
  ) async {
    try {
      var url = Uri.https(ip, '/api/login');
      var response = await http
          .post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },

            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        return ApiReport(true, "Login Worked!");
      } else if (response.statusCode == 404) {
        return ApiReport(false, "Incorrect Login information.");
      }
    } on TimeoutException catch (_) {
      return ApiReport(
        false,
        "Cannot communicate with server... Try again later",
      );
    }
    return ApiReport(false, "An uncaught error occured.");
  }

  static Future<ApiReport> deleteAccount(
    String username,
    String password,
  ) async {
    try {
      var url = Uri.https(ip, '/api/deleteAccount');
      var response = await http
          .post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'username': username,
              'password': password,
            }),
          )
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 201) {
        return ApiReport(true, "Account deleted.");
      } else {
        Map body = jsonDecode(response.body);
        return ApiReport(false, body["message"]);
      }
    } on TimeoutException catch (_) {
      return ApiReport(
        false,
        "Cannot communicate with server... Try again later",
      );
    }
  }

  static Future<ApiReport> changeUsername(
    String username,
    String password,
    String newUsername,
  ) async {
    try {
      var url = Uri.https(ip, '/api/changeUsername');
      var response = await http
          .post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'username': username,
              'password': password,
              'new_username': newUsername,
            }),
          )
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 201) {
        return ApiReport(true, "Username updated!");
      } else {
        Map body = jsonDecode(response.body);
        return ApiReport(false, body["message"]);
      }
    } on TimeoutException catch (_) {
      return ApiReport(
        false,
        "Cannot communicate with server... Try again later",
      );
    }
  }

  static Future<ApiReport> changePassword(
    String username,
    String password,
    String newPassword,
  ) async {
    try {
      var url = Uri.https(ip, '/api/changePassword');
      var response = await http
          .post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'username': username,
              'password': password,
              'new_password': newPassword,
            }),
          )
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 201) {
        return ApiReport(true, "Password updated!");
      } else {
        Map body = jsonDecode(response.body);
        return ApiReport(false, body["message"]);
      }
    } on TimeoutException catch (_) {
      return ApiReport(
        false,
        "Cannot communicate with server... Try again later",
      );
    }
  }

}

class ApiReport {
  ApiReport(this.result, this.message);

  final bool result;
  final String message;
}
