import 'dart:core';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';
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

    await Hive.openBox<EnvelopeData>("envelopes");
    await Hive.openBox<TransactionData>("transactions");
    await Hive.openBox<BadgeData>("badges");
    await Hive.openBox("streaks");
    await Hive.openBox("userData");

    await HiveDatabase.initBadges();
    await HiveDatabase.initStreak();
    await HiveDatabase.updateAppOpenStreak();
  }

  static Box getUserData() {
    try {
      return Hive.box("userData");
    } catch (e) {
      throw Exception("UserData box not initialized");
    }
  }

  static Box<EnvelopeData> getEnvelopes() {
    try {
      return Hive.box<EnvelopeData>("envelopes");
    } catch (e) {
      throw Exception("Envelopes box not initialized");
    }
  }

  static Box<TransactionData> getTransactions() {
    try {
      return Hive.box<TransactionData>("transactions");
    } catch (e) {
      throw Exception("Transactions box not initialized");
    }
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

  // Returns a single badge by name, returns null if not found
  static BadgeData? getBadgeByName(String name) {
    final badges = getBadges();
    return badges.get(name);
  }

  // Unlocks a badge by name if it hasn't been unlocked yet
  static Future<void> unlockBadge(String badgeName) async {
    final badges = getBadges();
    final badge = badges.get(badgeName);

    if (badge != null && !badge.isUnlocked) {
      badge.isUnlocked = true;
      badge.dateEarned = DateTime.now();
      await badge.save();
    }
  }

  // Call with very first import funds
  static Future<void> checkImportBadges() async {
    await unlockBadge("Purrfect Start");
  }

  // Call when user makes any deposity into an envelope
  static Future<void> checkDepositBadges(double totalDeposited) async {
    if (totalDeposited >= 100) await unlockBadge("Pawsitive Progress");
    if (totalDeposited >= 1000) await unlockBadge("Whisker Wealth");
  }

  // Call when user creates an envelope
  static Future<void> checkEnvelopeBadges(int envelopeCount) async {
    if (envelopeCount >= 1) await unlockBadge("Kitten Cache");
    if (envelopeCount >= 3) await unlockBadge("Claw-ver Saver");
    if (envelopeCount >= 9) await unlockBadge("Nine Lives");
  }

  // Call when user transfers money between envelopes
  static Future<void> checkTransferBadges() async {
    await unlockBadge("Meow-mentum");
  }

  // Call when user shares an envelope
  static Future<void> checkSharingBadges() async {
    await unlockBadge("Purrtnership");
  }

  // Call whenuser reaches a savings goal
  static Future<void> checkGoalBadges() async {
    await unlockBadge("Claws for Celebration");
  }

  // Call when user deposits into multiple envelopes in one day
  static Future<void> checkDailyDepsoitBadges(
    int envelopesDepositedToday,
  ) async {
    if (envelopesDepositedToday >= 3) await unlockBadge("Purrsistence");
    if (envelopesDepositedToday >= 5) await unlockBadge("Pawductivity");
  }

  //  Clears all badge data . TESTING PURPOSES ONLY
  static Future<void> clearBadges() async {
    Box badges = getBadges();
    stderr.writeln(
      "Clearing badges. This should only be used for testing purposes.",
    );
    await badges.clear();
  }

  // Clears all streaks data. TESTING PURPOSES ONLY
  static Future<void> clearStreaks() async {
    Box streaks = getStreaks();
    stderr.writeln(
      "Clearing streaks. This should only be used for testing purposes.",
    );
    await streaks.clear();
  }

  // Call this once when the user first creates an account
  // Will pre-populate all badges as locked
  static Future<void> initBadges() async {
    final badges = getBadges();

    if (badges.isNotEmpty) return;

    final List<BadgeData> allBadges = [
      BadgeData(
        name: "Purrfect Start",
        description: "Make your first deposit",
        isUnlocked: false,
      ),
      BadgeData(
        name: "Kitten Cache",
        description: "Create your first envelope",
        isUnlocked: false,
      ),
      BadgeData(
        name: "Claw-ver Saver",
        description: "Create your third envelope",
        isUnlocked: false,
      ),
      BadgeData(
        name: "Nine Lives",
        description: "Create your 9th envelope",
        isUnlocked: false,
      ),
      BadgeData(
        name: "Pawsitive Progress",
        description: "Deposit your first \$100 into an envelope",
        isUnlocked: false,
      ),
      BadgeData(
        name: "Whisker Wealth",
        description: "Deposit your first \$1000 into an envelope",
        isUnlocked: false,
      ),
      BadgeData(
        name: "Meow-mentum",
        description: "Move money between envelopes for the first time",
        isUnlocked: false,
      ),
      BadgeData(
        name: "Kitten Saver",
        description: "Deposit money for three consecutive days",
        isUnlocked: false,
      ),
      BadgeData(
        name: "Purrfessional Saver",
        description: "Deposit money for seven consecutive days",
        isUnlocked: false,
      ),
      BadgeData(
        name: "Purrseverence",
        description: "Deposit money for 10 consecutive days",
        isUnlocked: false,
      ),
      BadgeData(
        name: "Purrtnership",
        description: "Share an envelope with another user for the first time",
        isUnlocked: false,
      ),
      BadgeData(
        name: "Claws for Celebration",
        description: "Reach a savings goal for the first time",
        isUnlocked: false,
      ),
      BadgeData(
        name: "Curiosity Streak",
        description: "Open the app for 3 consecutive days",
        isUnlocked: false,
      ),
      BadgeData(
        name: "Pawsitive Habits",
        description: "Open the app for 7 consecutive days",
        isUnlocked: false,
      ),
      BadgeData(
        name: "Purrsistence",
        description: "Deposit into 3 different envelopes on the same day",
        isUnlocked: false,
      ),
      BadgeData(
        name: "Pawductivity",
        description: "Deposit into 5 different envelopes on the same day",
        isUnlocked: false,
      ),
    ];

    for (final badge in allBadges) {
      await badges.put(badge.name, badge);
    }
  }

  static Future<void> initStreak() async {
    final streaks = getStreaks();

    // Only initialize if the streak hasn't been set up yet
    if (streaks.isNotEmpty) return;

    // Monthly saving streak
    await streaks.put('savingStreakCount', 0);
    await streaks.put('lastDepositDate', null);

    // App open streak
    await streaks.put('appOpenStreakCount', 0);
    await streaks.put('lastAppOpenDate', null);

    // Daily deposit streak
    await streaks.put('depositDayStreakCount', 0);
    await streaks.put('lastDepositDayDate', null);
  }

  static Future<void> updateSavingStreak() async {
    final streaks = getStreaks();

    final int currentStreak = streaks.get('savingStreakCount', defaultValue: 0);
    final DateTime? lastDeposit = streaks.get('lastDepositDate');
    final DateTime now = DateTime.now();

    if (lastDeposit == null) {
      // First Deposit ever
      await streaks.put('savingStreakCount', 1);
    } else {
      // Check if user already deposited this month
      final bool sameMonth =
          lastDeposit.year == now.year && lastDeposit.month == now.month;

      // Return nothing if they alreayd deposited this month
      if (sameMonth) return;

      // Determine what last month was (Takes care of the January -> december rollover)
      final int prevMonth = now.month == 1 ? 12 : now.month - 1;
      final int prevYear = now.month == 1 ? now.year - 1 : now.year;
      //Check if the last deposit was in the previous calendar month
      final bool depositedLastMonth =
          lastDeposit.year == prevYear && lastDeposit.month == prevMonth;

      if (depositedLastMonth) {
        // Deposited last month, extend the streak
        await streaks.put('savingStreakCount', currentStreak + 1);
      } else {
        // Missed, reset the streak
        await streaks.put('savingStreakCount', 1);
      }
    }
    // Save todays date to compare againt next time
    await streaks.put('lastDepositDate', now);
  }

  static Future<void> updateDepositDayStreak() async {
    final streaks = getStreaks();
    final int currentStreak = streaks.get(
      'depositDayStreakCount',
      defaultValue: 0,
    );
    final DateTime? lastDepositDay = streaks.get('lastDepositDayDate');
    // Strip the time off to only compare calendar dates, not exact timestamps
    final DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (lastDepositDay == null) {
      // First deposit ever, start streak
      await streaks.put('depositDayStreakCount', 1);
    } else {
      // Strip time off last deposit date before comparing
      final DateTime lastDay = DateTime(
        lastDepositDay.year,
        lastDepositDay.month,
        lastDepositDay.day,
      );
      final int daysDiff = today.difference(lastDay).inDays;

      if (daysDiff == 0) {
        // Already deposited toay so no change
        return;
      } else if (daysDiff == 1) {
        // Deposited yesterday, extend streak
        await streaks.put('depositDayStreakCount', currentStreak + 1);
      } else {
        // Missed one day min, reset streak
        await streaks.put('depositDayStreakCount', 1);
      }
    }
    // Save today's date to compare against next time
    await streaks.put('lastDepositDayDate', DateTime.now());

    // Check if updated streak hit badge thresholds and unlock badges
    final int newStreak = streaks.get('depositDayStreakCount', defaultValue: 0);
    if (newStreak >= 3) await unlockBadge("Kitten Saver");
    if (newStreak >= 7) await unlockBadge("Purrfessional Saver");
    if (newStreak >= 10) await unlockBadge("Purrseverence");
  }

  static Future<void> updateAppOpenStreak() async {
    final streaks = getStreaks();

    final int currentStreak = streaks.get(
      'appOpenStreakCount',
      defaultValue: 0,
    );
    final DateTime? lastOpen = streaks.get('lastAppOpenDate');
    final DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (lastOpen == null) {
      // First time opening the app
      await streaks.put('appOpenStreakCount', 1);
    } else {
      final DateTime lastOpenDay = DateTime(
        lastOpen.year,
        lastOpen.month,
        lastOpen.day,
      );
      final int daysDiff = today.difference(lastOpenDay).inDays;

      if (daysDiff == 0) {
        // ALready opened today, don't change the streak
        return;
      } else if (daysDiff == 1) {
        // Opened yesterday, extend the streak
        await streaks.put('appOpenStreakCount', currentStreak + 1);
      } else {
        // Missed a day, reset the streak
        await streaks.put('appOpenStreakCount', 1);
      }
    }

    await streaks.put('lastAppOpenDate', DateTime.now());

    // Check streak badges
    final int newStreak = streaks.get('appOpenStreakCount', defaultValue: 0);
    if (newStreak >= 3) await unlockBadge("Curiosity Streak");
    if (newStreak >= 7) await unlockBadge("Pawsitive Habits");
  }

  static Future<void> newEnvelope(
    String name,
    int color,
    double budgetTarget,
    double balance,
    int displayOrder,
  ) async {
    Box? envelopes = getEnvelopes();
    envelopes.add(
      EnvelopeData(
        name: name,
        color: color,
        budgetTarget: budgetTarget,
        balance: balance,
        displayOrder: displayOrder,
        local: true,
        users: {},
      ),
    );
  }

  static Future<void> newTransaction(
    EnvelopeData? wEnvelopeId,
    EnvelopeData? dEnvelopeId,
    double amount,
    int? source,
  ) async {
    Box? transactions = getTransactions();
    transactions.add(
      TransactionData(
        wEnvelope: wEnvelopeId,
        dEnvelope: dEnvelopeId,
        amount: amount,
        timeStamp: DateTime.now(),
        source: source,
      ),
    );
  }

  static Future<void> transactionWithEdit(
    EnvelopeData? wEnvelopeId,
    EnvelopeData? dEnvelopeId,
    double amount,
    int? source,
  ) async {
    Box<EnvelopeData> envelopes = getEnvelopes();
    await Future.wait([
      if (wEnvelopeId != null) addOrRemoveEnevelopeBalance(wEnvelopeId, -amount),
      if (dEnvelopeId != null) addOrRemoveEnevelopeBalance(dEnvelopeId, amount),
      newTransaction(wEnvelopeId, dEnvelopeId, amount, source)
    ]);
  }

  static Future<void> addOrRemoveEnevelopeBalance(EnvelopeData envelopeId, double value) async{
    Box<EnvelopeData> envelopes = getEnvelopes();
    envelopeId.balance += value;
    await envelopes.put(envelopeId.key, envelopeId);
  }

  static Future<bool> deleteEnvelope(EnvelopeData envelope) async {
    try{
      Box<EnvelopeData> envelopes = getEnvelopes();
      importFunds(envelope.balance);
      envelopes.delete(envelope.key);
      return true;
    }catch (e, stacktrace){
      if (kDebugMode) {
        print("The error $e occured while deleting envelope.\n$stacktrace");
      }
      return false;
    }
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

  static Future<void> clearData() async {
    Box envelopes = getEnvelopes();
    Box transactions = getTransactions();
    Box badges = getBadges();
    Box streaks = getStreaks();
    Box userData = getUserData();
    stderr.writeln(
      "Clearing Hive Database. This should only be used for testing purposes.",
    );
    await envelopes.clear();
    await transactions.clear();
    await badges.clear();
    await streaks.clear();
    await userData.clear();
  }

  static Future<void> addLoginData(String username, String password) async {
    final Box userData = getUserData();
    userData.put("username", username);
    userData.put("password", password);
  }

  static Future<void> importFunds(double amount) async {
    final userData = getUserData();
    final double current = userData.get('balance', defaultValue: 0.0);
    await userData.put('balance', current + amount);
  }
}
