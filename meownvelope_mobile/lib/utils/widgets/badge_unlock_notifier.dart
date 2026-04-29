import 'package:flutter/foundation.dart';

class BadgeUnlockNotifier {
  static final ValueNotifier<String?> unlockedBadge = ValueNotifier<String?>(null);

  static void show(String badgeName) {
    print("BadgeUnlockNotifier.show: $badgeName");
    unlockedBadge.value = badgeName;
  }

  static void clear() {
    print("BadgeUnlockNotifier.clear");
    unlockedBadge.value = null;
  }
}