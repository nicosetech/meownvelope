import 'package:meownvelope_mobile/data_types/badge_data.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';
import "dart:io";
import 'package:meownvelope_mobile/utils/widgets/badge_unlock_notifier.dart';

class BadgeRepository {
    // Returns a single badge by name, returns null if not found
    static BadgeData? getBadgeByName(String name) {
        final badges = HiveDatabase.getBadges();
        return badges.get(name);
    }

    // Unlocks a badge by name if it hasn't been unlocked yet
    static Future<void> unlockBadge(String badgeName) async {
        final badges = HiveDatabase.getBadges();
        final badge = badges.get(badgeName);

        if (badge == null) {
          stderr.writeln("Tried to unlock missing badge: $badgeName");
          return;
        }

        if (!badge.isUnlocked) {
            badge.isUnlocked = true;
            badge.dateEarned = DateTime.now();
            await badge.save();

            BadgeUnlockNotifier.show(badgeName);
        }
    }

    // Call this once when the user first creates an account
    // Will pre-populate all badges as locked
    static Future<void> initBadges() async {
        final badges = HiveDatabase.getBadges();

        if (badges.isNotEmpty) return;

        final List<BadgeData> allBadges = [
            BadgeData(name: "Purrfect Start", description: "Make your first deposit", isUnlocked: false),
            BadgeData(name: "Kitten Cache", description: "Create your first envelope", isUnlocked: false),
            BadgeData(name: "Claw-ver Saver", description: "Create your third envelope", isUnlocked: false),
            BadgeData(name: "Nine Lives", description: "Create your 9th envelope", isUnlocked: false),
            BadgeData(name: "Pawsitive Progress", description: "Deposit your first \$100 into an envelope", isUnlocked: false),
            BadgeData(name: "Whisker Wealth", description: "Deposit your first \$1000 into an envelope", isUnlocked: false),
            BadgeData(name: "Meow-mentum", description: "Move money between envelopes for the first time", isUnlocked: false),
            BadgeData(name: "Kitten Saver", description: "Deposit money for three consecutive days", isUnlocked: false),
            BadgeData(name: "Purrfessional Saver", description: "Deposit money for seven consecutive days", isUnlocked: false),
            BadgeData(name: "Purrseverence", description: "Deposit money for 10 consecutive days", isUnlocked: false),
            BadgeData(name: "Purrtnership", description: "Share an envelope with another user for the first time", isUnlocked: false),
            BadgeData(name: "Claws for Celebration", description: "Reach a savings goal for the first time", isUnlocked: false),
            BadgeData(name: "Curiosity Streak", description: "Open the app for 3 consecutive days", isUnlocked: false),
            BadgeData(name: "Pawsitive Habits", description: "Open the app for 7 consecutive days", isUnlocked: false),
            BadgeData(name: "Purrsistence", description: "Deposit into 3 different envelopes on the same day", isUnlocked: false),
            BadgeData(name: "Pawductivity", description: "Deposit into 5 different envelopes on the same day", isUnlocked: false),
        ];

        for (final badge in allBadges) {
            await badges.put(badge.name, badge);
        }
    }

    // Call with very first import funds
    static Future<void> checkImportBadges() async {
      await unlockBadge("Purrfect Start");
    }

    // Call when user makes any deposit into an envelope
    static Future<void> checkDepositBadges(double totalDeposited) async {
      if (totalDeposited >= 100) await unlockBadge("Pawsitive Progress");
      if (totalDeposited >= 1000) await unlockBadge("Whisker Wealth");
    }

    // Call when user deposits into multiple envelopes in one day
    static Future<void> checkDailyDepositBadges(int envelopesDepositedToday) async {
      if (envelopesDepositedToday >= 3) await unlockBadge("Purrsistence");
      if (envelopesDepositedToday >= 5) await unlockBadge("Pawductivity");
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

    //  Clears all badge data . TESTING PURPOSES ONLY
    static Future<void> clearBadges() async {
        stderr.writeln(
          "Clearing badges. This should only be used for testing purposes.",
        );
      await HiveDatabase.getBadges().clear();
    }
}