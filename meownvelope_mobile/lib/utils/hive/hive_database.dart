import 'dart:core';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:meownvelope_mobile/data/repositories/badge_repository.dart';
import 'package:meownvelope_mobile/data/repositories/envelope_repository.dart';
import 'package:meownvelope_mobile/data/repositories/streak_repository.dart';
import 'package:meownvelope_mobile/data/repositories/transaction_repository.dart';
import 'package:meownvelope_mobile/data/repositories/user_data_repository.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';
import 'package:meownvelope_mobile/data_types/recurring_deposit_data.dart';
import 'package:meownvelope_mobile/data_types/transaction_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:meownvelope_mobile/data_types/badge_data.dart';
class HiveDatabase {
  static Future<void> initHiveDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter<EnvelopeData>(EnvelopeDataAdapter());
    Hive.registerAdapter<TransactionData>(TransactionDataAdapter());
    Hive.registerAdapter<BadgeData>(BadgeDataAdapter());
    Hive.registerAdapter<RecurringDepositData>(RecurringDepositDataAdapter());

    await Hive.openBox<EnvelopeData>("envelopes");
    await Hive.openBox<TransactionData>("transactions");
    await Hive.openBox<BadgeData>("badges");
    await Hive.openBox("streaks");
    await Hive.openBox("userData");
    await Hive.openBox<RecurringDepositData>("recurringDeposits");

    await BadgeRepository.initBadges();
    await StreakRepository.initStreak();
    await StreakRepository.updateAppOpenStreak();
  }

  // Returns the badges box. Use this to read badge data
  static Box<BadgeData> getBadges() {
    try {
      return Hive.box<BadgeData>("badges");
    } catch (e) {
      throw Exception("Badges box not initialized");
    }
  }

  // Retruns the streaks box. Use this to read streaks data
  static Box getStreaks() {
    try {
      return Hive.box("streaks");
    } catch (e) {
      throw Exception("Streaks box not initialized");
    }
  }

  static Future<void> clearData() async {
    Box envelopes = EnvelopeRepository.getEnvelopes();
    Box transactions = TransactionRepository.getTransactions();
    Box badges = getBadges();
    Box streaks = getStreaks();
    Box userData = UserDataRepository.getUserData();
    stderr.writeln(
      "Clearing Hive Database. This should only be used for testing purposes.",
    );
    await envelopes.clear();
    await transactions.clear();
    await badges.clear();
    await streaks.clear();
    await userData.clear();
  }
}
