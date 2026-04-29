import 'package:flutter/material.dart';

class BadgeModel {
  final String badgeKey;
  final String title;
  final IconData icon;
  final Color color;

  const BadgeModel({
    required this.badgeKey,
    required this.title,
    required this.icon,
    required this.color,
  });
}