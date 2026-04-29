import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/data/badges/badge_model.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';

class BadgeDefinitions {
  static final List<Color> _colors = MeownvelopeColors.presetEnvelopeColors;

  static final List<BadgeModel> all = [
    BadgeModel(
      badgeKey: 'Purrfect Start',
      title: 'Purrfect Start',
      icon: Icons.pets,
      color: _colors[0],
    ),
    BadgeModel(
      badgeKey: 'Kitten Cache',
      title: 'Kitten Cache',
      icon: Icons.mail_outline,
      color: _colors[1],
    ),
    BadgeModel(
      badgeKey: 'Claw-ver Saver',
      title: 'Clawver Saver',
      icon: Icons.email,
      color: _colors[2],
    ),
    BadgeModel(
      badgeKey: 'Nine Lives',
      title: 'Nine Lives',
      icon: Icons.favorite_border,
      color: _colors[3],
    ),
    BadgeModel(
      badgeKey: 'Pawsitive Progress',
      title: 'Pawsitive Progress',
      icon: Icons.attach_money,
      color: _colors[4],
    ),
    BadgeModel(
      badgeKey: 'Whisker Wealth',
      title: 'Whisker Wealth',
      icon: Icons.savings_outlined,
      color: _colors[5],
    ),
    BadgeModel(
      badgeKey: 'Meow-mentum',
      title: 'Meow-mentum',
      icon: Icons.mark_email_unread_outlined,
      color: _colors[6],
    ),
    BadgeModel(
      badgeKey: 'Kitten Saver',
      title: 'Kitten Saver',
      icon: Icons.local_fire_department_outlined,
      color: _colors[7],
    ),
    BadgeModel(
      badgeKey: 'Purrfessional Saver',
      title: 'Purrfessional Saver',
      icon: Icons.whatshot_outlined,
      color: _colors[0],
    ),
    BadgeModel(
      badgeKey: 'Purrseverence',
      title: 'Purrseverance',
      icon: Icons.verified_outlined,
      color: _colors[1],
    ),
    BadgeModel(
      badgeKey: 'Purrtnership',
      title: 'Purrtnership',
      icon: Icons.people_outline,
      color: _colors[2],
    ),
    BadgeModel(
      badgeKey: 'Claws for Celebration',
      title: 'Claws for Celebration',
      icon: Icons.auto_awesome_outlined,
      color: _colors[3],
    ),
    BadgeModel(
      badgeKey: 'Curiosity Streak',
      title: 'Curiosity Streak',
      icon: Icons.remove_red_eye_outlined,
      color: _colors[4],
    ),
    BadgeModel(
      badgeKey: 'Pawsitive Habits',
      title: 'Pawsitive Habits',
      icon: Icons.visibility_outlined,
      color: _colors[5],
    ),
    BadgeModel(
      badgeKey: 'Purrsistence',
      title: 'Purrsistence',
      icon: Icons.compare_arrows_outlined,
      color: _colors[6],
    ),
    BadgeModel(
      badgeKey: 'Pawductivity',
      title: 'Pawductivity',
      icon: Icons.swap_horiz_outlined,
      color: _colors[7],
    ),
  ];

  static BadgeModel? byKey(String badgeKey) {
    for (final badge in all) {
      if (badge.badgeKey == badgeKey) return badge;
    }
    return null;
  }
}