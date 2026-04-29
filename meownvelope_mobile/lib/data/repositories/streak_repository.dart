import 'package:meownvelope_mobile/utils/hive/hive_database.dart';
import 'package:meownvelope_mobile/data/repositories/badge_repository.dart';
import 'dart:io';

class StreakRepository {

  static Future<void> initStreak() async {
    final streaks = HiveDatabase.getStreaks();

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
    final streaks = HiveDatabase.getStreaks();

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
    final streaks = HiveDatabase.getStreaks();
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
    if (newStreak >= 3) await BadgeRepository.unlockBadge("Kitten Saver");
    if (newStreak >= 7) await BadgeRepository.unlockBadge("Purrfessional Saver");
    if (newStreak >= 10) await BadgeRepository.unlockBadge("Purrseverence");
  }

  static Future<void> updateAppOpenStreak() async {
    final streaks = HiveDatabase.getStreaks();

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
    if (newStreak >= 3) await BadgeRepository.unlockBadge("Curiosity Streak");
    if (newStreak >= 7) await BadgeRepository.unlockBadge("Pawsitive Habits");
  }
  // Clears all streaks data. TESTING PURPOSES ONLY
  static Future<void> clearStreaks() async {
    stderr.writeln(
        "Clearing streaks. This should only be used for testing purposes.",
    );
    await HiveDatabase.getStreaks().clear();
  }
}