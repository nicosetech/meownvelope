import 'package:flutter_test/flutter_test.dart';
import 'package:meownvelope_mobile/utils/widgets/badge_unlock_notifier.dart';

void main() {
  group('BadgeUnlockNotifier', () {
    setUp(() {
      // Reset before each test
      BadgeUnlockNotifier.unlockedBadge.value = null;
    });

    test('show sets unlockedBadge to the provided badge name', () {
      BadgeUnlockNotifier.show('test_badge');

      expect(BadgeUnlockNotifier.unlockedBadge.value, 'test_badge');
    });

    test('clear resets unlockedBadge to null', () {
      BadgeUnlockNotifier.show('test_badge');

      BadgeUnlockNotifier.clear();

      expect(BadgeUnlockNotifier.unlockedBadge.value, isNull);
    });

    test('show notifies listeners when badge is unlocked', () {
      bool wasNotified = false;

      void listener() {
        wasNotified = true;
      }

      BadgeUnlockNotifier.unlockedBadge.addListener(listener);

      BadgeUnlockNotifier.show('test_badge');

      expect(wasNotified, isTrue);

      // Clean up
      BadgeUnlockNotifier.unlockedBadge.removeListener(listener);
    });
  });
}