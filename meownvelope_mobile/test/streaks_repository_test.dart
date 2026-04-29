import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:meownvelope_mobile/data/repositories/streak_repository.dart';
import 'package:meownvelope_mobile/data/repositories/badge_repository.dart';
import 'package:meownvelope_mobile/data_types/badge_data.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(BadgeDataAdapter());
    }
    await Hive.openBox<BadgeData>("badges");
    await Hive.openBox("streaks");
    await BadgeRepository.initBadges();
    await StreakRepository.initStreak();
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  group('StreakRepository - initStreak', () {
    test('initializes savingStreakCount to 0', () {
      final streaks = Hive.box("streaks");
      expect(streaks.get('savingStreakCount'), 0);
    });

    test('initializes depositDayStreakCount to 0', () {
      final streaks = Hive.box("streaks");
      expect(streaks.get('depositDayStreakCount'), 0);
    });

    test('initializes appOpenStreakCount to 0', () {
      final streaks = Hive.box("streaks");
      expect(streaks.get('appOpenStreakCount'), 0);
    });
  });

  group('StreakRepository - updateSavingStreak', () {
    test('increments savingStreakCount to 1 on first deposit', () async {
      await StreakRepository.updateSavingStreak();
      final streaks = Hive.box("streaks");
      expect(streaks.get('savingStreakCount'), 1);
    });
  });

  group('StreakRepository - updateDepositDayStreak', () {
    test('increments depositDayStreakCount to 1 on first deposit', () async {
      await StreakRepository.updateDepositDayStreak();
      final streaks = Hive.box("streaks");
      expect(streaks.get('depositDayStreakCount'), 1);
    });
  });

  group('StreakRepository - updateAppOpenStreak', () {
    test('increments appOpenStreakCount to 1 on first open', () async {
      await StreakRepository.updateAppOpenStreak();
      final streaks = Hive.box("streaks");
      expect(streaks.get('appOpenStreakCount'), 1);
    });
  });
}