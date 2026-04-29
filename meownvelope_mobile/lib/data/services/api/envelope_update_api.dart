import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:meownvelope_mobile/data/repositories/envelope_repository.dart';
import 'package:meownvelope_mobile/data/repositories/user_data_repository.dart';
import 'package:meownvelope_mobile/data/services/api/api_tools.dart';
import 'package:meownvelope_mobile/data/services/api/websocket_client.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';

class EnvelopeUpdateApi {
  static Future<ApiReport> batchRequest(
    String username,
    String password,
  ) async {
    try {
      var url = Uri.https(ApiTools.ip, '/api/batchRequest');
      var response = await http
          .post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(Duration(seconds: 10));
      Map body = jsonDecode(response.body);
      print("Batch request: ${body}");
      if (response.statusCode == 200) {
        EnvelopeRepository.updateBatchData(body["envelopes"]);
        return ApiReport(true, "Envelopes collected!");
      } else if (body["message"] == "Invalid credentials") {
        return ApiReport(
          false,
          "Wrong username or password. Please try again.",
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

  static Future<ApiReport> editEnvelopeBalance(
    String enevelopeId,
    int changeAmount,
  ) async {
    try {
      var url = Uri.https(ApiTools.ip, '/api/editEnvelopeBalance');
      var response = await http
          .patch(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'username': await UserDataRepository.getUsername(),
              'password': await UserDataRepository.getPassword(),
              'envelope_data': {
                "envelope_id": enevelopeId,
                "balance_change_amount": changeAmount,
              },
            }),
          )
          .timeout(Duration(seconds: 10));
      Map body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiReport(true, "Envelope balance updated!");
      } else {
        return ApiReport(false, body["message"]);
      }
    } on TimeoutException catch (_) {
      return ApiReport(
        false,
        "Cannot communicate with server... Try again later",
      );
    } on Exception catch (_) {
      return ApiReport(false, "An unexpected error occured.");
    }
  }

  static Future<ApiReport> addEnvelopeToServer(EnvelopeData envelope) async {
    try {
      var url = Uri.https(ApiTools.ip, '/api/createEnvelope');
      var response = await http
          .post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'username': await UserDataRepository.getUsername(),
              'password': await UserDataRepository.getPassword(),
              'envelope_data': {
                "name": envelope.name,
                "balance": envelope.balance.toInt(),
                "budget_target": envelope.budgetTarget.toInt(),
              },
            }),
          )
          .timeout(Duration(seconds: 10));
      Map body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        String envelopeId = body["envelope_id"];
        await EnvelopeRepository.addServerID(envelope, envelopeId);
        WebsocketClient.lateJoinRoom(envelopeId);
        return ApiReport(true, "Envelope added to server!");
      } else {
        return ApiReport(false, body["message"]);
      }
    } on TimeoutException catch (_) {
      return ApiReport(
        false,
        "Cannot communicate with server... Try again later",
      );
    } on Exception catch (_) {
      return ApiReport(false, "An unexpected error occured.");
    }
  }

  static Future<ApiReport> requestShareCode(String serverId) async {
    try {
      var url = Uri.https(ApiTools.ip, '/api/requestShareCode');
      var response = await http
          .post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'username': await UserDataRepository.getUsername(),
              'password': await UserDataRepository.getPassword(),
              'envelope_id': serverId,
            }),
          )
          .timeout(Duration(seconds: 10));
      Map body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        String shareCode = body["share_code"];
        return ApiReport(true, shareCode);
      } else {
        return ApiReport(false, body["message"]);
      }
    } on TimeoutException catch (_) {
      return ApiReport(
        false,
        "Cannot communicate with server... Try again later",
      );
    } on Exception catch (_) {
      return ApiReport(false, "An unexpected error occured.");
    }
  }

  static Future<ApiReport> addUserToEnvelope(String shareCode) async {
    try {
      var url = Uri.https(ApiTools.ip, '/api/addUserToEnvelope');
      var response = await http
          .put(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'username': await UserDataRepository.getUsername(),
              'password': await UserDataRepository.getPassword(),
              'share_code': shareCode,
            }),
          )
          .timeout(Duration(seconds: 10));
      Map body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        Map<String, dynamic> envelopeData = body["envelope"];
        print("Got envelope ${envelopeData}");
        await EnvelopeRepository.newEnvelope(
          envelopeData["name"],
          0xffffffff,
          envelopeData["budget_target"].toDouble(),
          envelopeData["balance"].toDouble(),
          await EnvelopeRepository.envelopeOrder(true),
          serverId: envelopeData["envelope_id"]
        );
        WebsocketClient.lateJoinRoom(envelopeData["envelope_id"]);
        return ApiReport(true, "Envelope Added!");
      } else {
        return ApiReport(false, body["message"]);
      }
    } on TimeoutException catch (_) {
      return ApiReport(
        false,
        "Cannot communicate with server... Try again later",
      );
    } on Exception catch (_) {
      return ApiReport(false, "An unexpected error occured.");
    }
  }
}
