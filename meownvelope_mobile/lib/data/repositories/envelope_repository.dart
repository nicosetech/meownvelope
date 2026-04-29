import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:meownvelope_mobile/data/repositories/user_data_repository.dart';
import 'package:meownvelope_mobile/data/services/api/envelope_update_api.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';

class EnvelopeRepository {
  static Box<EnvelopeData> getEnvelopes() {
    try {
      return Hive.box<EnvelopeData>("envelopes");
    } catch (e) {
      throw Exception("Envelopes box not initialized");
    }
  }

  static Future<void> newEnvelope(
    String name,
    int color,
    double budgetTarget,
    double balance,
    int displayOrder, {
    String? serverId,
  }) async {
    Box? envelopes = getEnvelopes();
    envelopes.add(
      EnvelopeData(
        name: name,
        color: color,
        budgetTarget: budgetTarget,
        balance: balance,
        displayOrder: displayOrder,
        serverEnvID: serverId,
        users: {},
      ),
    );
  }

  static Future<bool> deleteEnvelope(EnvelopeData envelope) async {
    try {
      Box<EnvelopeData> envelopes = getEnvelopes();
      UserDataRepository.importFunds(envelope.balance);
      envelopes.delete(envelope.key);
      return true;
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print("The error $e occured while deleting envelope.\n$stacktrace");
      }
      return false;
    }
  }

  static Future<void> addOrRemoveEnevelopeBalance(
    EnvelopeData envelopeId,
    double value,
  ) async {
    Box<EnvelopeData> envelopes = getEnvelopes();
    print(envelopeId);
    if (envelopeId.serverEnvID != null) {
      EnvelopeUpdateApi.editEnvelopeBalance(
        envelopeId.serverEnvID!,
        value.toInt(),
      );
      return;
    }
    envelopeId.balance += value;
    await envelopes.put(envelopeId.key, envelopeId);
  }

  static Future<int> envelopeOrder(bool placeAtStart) async {
    final enevelopes = getEnvelopes();

    if (placeAtStart) {
      for (final envelope in enevelopes.values) {
        envelope.displayOrder = envelope.displayOrder + 1;
        enevelopes.put(envelope.key, envelope);
      }
      return 1;
    } else {
      return enevelopes.length + 1;
    }
  }

  static EnvelopeData? envelopeFromServerID(String serverID) {
    try {
      return getEnvelopes().values.firstWhere(
        (element) => element.serverEnvID == serverID,
      );
    } on StateError catch (_) {
      return null;
    }
  }

  static Future<void> updateBatchData(List<dynamic> envelopes) async {
    for (var i in envelopes) {
      EnvelopeData? localEnv = envelopeFromServerID(i["envelope_id"]);
      if (localEnv == null) {
        await newEnvelope(
          i["name"],
          0xffffffff,
          i["budget_target"].toDouble(),
          i["balance"].toDouble(),
          await envelopeOrder(false),
          serverId: i["envelope_id"],
        );
      } else {
        localEnv.budgetTarget = i["budget_target"].toDouble();
        localEnv.balance = i["balance"].toDouble();
        await getEnvelopes().put(localEnv.key, localEnv);
      }
    }
  }

  static Future<void> updateSingleEnvelope(
    Map<String, dynamic> envelope,
  ) async {
    EnvelopeData? localEnv = envelopeFromServerID(envelope["envelope_id"]);
    if (localEnv != null) {
      localEnv.balance = envelope["balance"].toDouble();
      await getEnvelopes().put(localEnv.key, localEnv);
    }
  }

  static Future<void> removeCloudEnvelopes() async {
    for (EnvelopeData i in getEnvelopes().values) {
      if (i.serverEnvID != null) {
        await deleteEnvelope(i);
      }
    }
  }

  static Future<void> addServerID(
    EnvelopeData envelope,
    String serverID,
  ) async {
    envelope.serverEnvID = serverID;
    await getEnvelopes().put(envelope.key, envelope);
  }
}
