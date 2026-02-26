import 'dart:core';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meownvelope_mobile/DataTypes/envelope_data.dart';
import 'package:meownvelope_mobile/DataTypes/transaction_data.dart';
import 'package:path_provider/path_provider.dart';

class HiveDatabase{
  static Future<void> initHiveDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter<EnvelopeData>(EnvelopeDataAdapter());
    Hive.registerAdapter<TransactionData>(TransactionDataAdapter());

    await Hive.openBox<EnvelopeData>("envelopes");
    await Hive.openBox<TransactionData>("transactions");
  }
  
  static Box<EnvelopeData> getEnvelopes(){
    try{
      return Hive.box<EnvelopeData>("envelopes");
    }catch(e){
      throw Exception("Envelopes box not initialized");
    }
  }

  static Box<TransactionData> getTransactions(){
    try{
      return Hive.box<TransactionData>("transactions");
    }catch(e){
      throw Exception("Transactions box not initialized");
    }
  }

  static Future<void> newEnvelope(String name, int color, double budgetTarget, double balance, int displayOrder) async{
    Box? envelopes = getEnvelopes();
    envelopes.add(EnvelopeData(name: name, color: color, budgetTarget: budgetTarget, balance: balance, displayOrder: displayOrder, local: true, users: {}));
  }

  static Future<void> newTransaction(EnvelopeData? wEnvelopeId, EnvelopeData? dEnvelopeId, double amount, int? source) async{
    Box? transactions = getTransactions();
    transactions.add(TransactionData(
      wEnvelope: wEnvelopeId,
      dEnvelope: dEnvelopeId,
      amount: amount,
      timeStamp: DateTime.now(),
      source: source
    ));
  }

  static Future<void> clearData() async {
    Box envelopes = getEnvelopes();
    Box transactions = getTransactions();
    stderr.writeln("Clearing Hive Database. This should only be used for testing purposes.");
    await envelopes.clear();
    await transactions.clear();
  }
}