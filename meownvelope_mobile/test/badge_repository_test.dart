import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:meownvelope_mobile/data/repositories/badge_repository.dart';
import 'package:meownvelope_mobile/data_types/badge_data.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
    if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(BadgeDataAdapter());
    }
    await Hive.openBox<BadgeData>("badges");
    await BadgeRepository.initBadges();
});

  tearDown(() async {
    await tearDownTestHive();
  });

  group('BadgeRepository - initBadges', () {
    test('populates all 16 badges as locked', () {
      final badges = Hive.box<BadgeData>("badges");
      expect(badges.length, 16);
      for (final badge in badges.values) {
        expect(badge.isUnlocked, false);
      }
    });
  });

  group('BadgeRepository - unlockBadge', () {
    test('sets isUnlocked to true', () async {
      await BadgeRepository.unlockBadge("Purrfect Start");
      final badge = BadgeRepository.getBadgeByName("Purrfect Start");
      expect(badge?.isUnlocked, true);
    });

    test('sets dateEarned to non-null DateTime', () async {
      await BadgeRepository.unlockBadge("Purrfect Start");
      final badge = BadgeRepository.getBadgeByName("Purrfect Start");
      expect(badge?.dateEarned, isNotNull);
    });
  });

  group('BadgeRepository - checkImportBadges', () {
    test('unlocks Purrfect Start', () async {
      await BadgeRepository.checkImportBadges();
      expect(BadgeRepository.getBadgeByName("Purrfect Start")?.isUnlocked, true);
    });
  });

  group('BadgeRepository - checkDepositBadges', () {
    test('unlocks Pawsitive Progress when deposited >= 100', () async {
      await BadgeRepository.checkDepositBadges(100);
      expect(BadgeRepository.getBadgeByName("Pawsitive Progress")?.isUnlocked, true);
    });

    test('unlocks Whisker Wealth when deposited >= 1000', () async {
      await BadgeRepository.checkDepositBadges(1000);
      expect(BadgeRepository.getBadgeByName("Whisker Wealth")?.isUnlocked, true);
    });
  });

  group('BadgeRepository - checkDailyDepositBadges', () {
    test('unlocks Purrsistence when 3 envelopes deposited', () async {
      await BadgeRepository.checkDailyDepositBadges(3);
      expect(BadgeRepository.getBadgeByName("Purrsistence")?.isUnlocked, true);
    });

    test('unlocks Pawductivity when 5 envelopes deposited', () async {
      await BadgeRepository.checkDailyDepositBadges(5);
      expect(BadgeRepository.getBadgeByName("Pawductivity")?.isUnlocked, true);
    });
  });

  group('BadgeRepository - checkEnvelopeBadges', () {
    test('unlocks Kitten Cache when envelope count >= 1', () async {
      await BadgeRepository.checkEnvelopeBadges(1);
      expect(BadgeRepository.getBadgeByName("Kitten Cache")?.isUnlocked, true);
    });

    test('unlocks Claw-ver Saver when envelope count >= 3', () async {
      await BadgeRepository.checkEnvelopeBadges(3);
      expect(BadgeRepository.getBadgeByName("Claw-ver Saver")?.isUnlocked, true);
    });

    test('unlocks Nine Lives when envelope count >= 9', () async {
      await BadgeRepository.checkEnvelopeBadges(9);
      expect(BadgeRepository.getBadgeByName("Nine Lives")?.isUnlocked, true);
    });
  });

  group('BadgeRepository - checkTransferBadges', () {
    test('unlocks Meow-mentum', () async {
      await BadgeRepository.checkTransferBadges();
      expect(BadgeRepository.getBadgeByName("Meow-mentum")?.isUnlocked, true);
    });
  });

  group('BadgeRepository - checkSharingBadges', () {
    test('unlocks Purrtnership', () async {
      await BadgeRepository.checkSharingBadges();
      expect(BadgeRepository.getBadgeByName("Purrtnership")?.isUnlocked, true);
    });
  });

  group('BadgeRepository - checkGoalBadges', () {
    test('unlocks Claws for Celebration', () async {
      await BadgeRepository.checkGoalBadges();
      expect(BadgeRepository.getBadgeByName("Claws for Celebration")?.isUnlocked, true);
    });
  });

}