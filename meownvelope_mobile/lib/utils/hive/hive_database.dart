import 'dart:core';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveDatabase{
  static Future<void> initHiveDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    await Hive.openBox("envelopes");
    await Hive.openBox("transactions");
  }
  
  static Box getEnvelopes(){
    try{
      return Hive.box("envelopes");
    }catch(e){
      throw Exception("Envelopes box not initialized");
    }
  }

  static Box getTransactions(){
    try{
      return Hive.box("transactions");
    }catch(e){
      throw Exception("Transactions box not initialized");
    }
  }

  static void newEnvelope(String name, int color, double budgetTarget, double balance, int displayOrder){
    Box? envelopes = getEnvelopes();
    envelopes.add({
      "name": name,
      "color": color,
      "local": true,
      "budgetTarget": budgetTarget,
      "balance": balance,
      "displayOrder": displayOrder,
      "users": <Int, String>{}
    });
  }

  static void newTransaction(int? wEnvelopeId, int? dEnvelopeId, double amount, int? source){
    Box? transactions = getTransactions();
    transactions.add({
      "wEnvelopeId": wEnvelopeId,
      "dEnvelopeId": dEnvelopeId,
      "amount": amount,
      "date": DateTime.now(),
      "source": source
    });
  }

  static Future<void> clearData() async {
    Box envelopes = getEnvelopes();
    Box transactions = getTransactions();
    stderr.writeln("Clearing Hive Database. This should only be used for testing purposes.");
    await envelopes.clear();
    await transactions.clear();
  }
}