import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';

class BadgeUnlockPopup extends StatelessWidget {
  final String badgeTitle;
  final IconData badgeIcon;
  final Color badgeColor;

  const BadgeUnlockPopup({
    super.key,
    required this.badgeTitle,
    required this.badgeIcon,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: MeownvelopeColors.lightBlue,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: MeownvelopeColors.darkBlue,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: MeownvelopeColors.darkBlue.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Badge Unlocked!',
              textAlign: TextAlign.center,
              style: martian(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MeownvelopeColors.darkBlue,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: MeownvelopeColors.darkBlue,
                  width: 2,
                ),
              ),
              child: Icon(
                badgeIcon,
                size: 48,
                color: MeownvelopeColors.darkBlue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              badgeTitle,
              textAlign: TextAlign.center,
              style: martian(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: MeownvelopeColors.darkBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}