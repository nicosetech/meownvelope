import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/data/badges/badge_definitions.dart';
import 'package:meownvelope_mobile/utils/widgets/badge_unlock_notifier.dart';
import 'package:meownvelope_mobile/utils/widgets/badge_unlock_popup.dart';

class BadgeUnlockListener extends StatefulWidget {
  final Widget child;

  const BadgeUnlockListener({
    super.key,
    required this.child,
  });

  @override
  State<BadgeUnlockListener> createState() => _BadgeUnlockListenerState();
}

class _BadgeUnlockListenerState extends State<BadgeUnlockListener> {
  @override
  void initState() {
    super.initState();
    BadgeUnlockNotifier.unlockedBadge.addListener(_handleBadgeUnlock);
  }

  @override
  void dispose() {
    BadgeUnlockNotifier.unlockedBadge.removeListener(_handleBadgeUnlock);
    super.dispose();
  }

  void _handleBadgeUnlock() {
    final badgeName = BadgeUnlockNotifier.unlockedBadge.value;
    if (badgeName == null || !mounted) return;

    final badge = BadgeDefinitions.byKey(badgeName);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => BadgeUnlockPopup(
          badgeTitle: badge?.title ?? badgeName,
          badgeIcon: badge?.icon ?? Icons.emoji_events,
          badgeColor: badge?.color ?? const Color(0xFFE8E2CC),
        ),
      );

      Future.delayed(const Duration(seconds: 3), () {
        if (!mounted) return;

        final navigator = Navigator.of(context, rootNavigator: true);
        if (navigator.canPop()) {
          navigator.pop();
        }

        BadgeUnlockNotifier.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}