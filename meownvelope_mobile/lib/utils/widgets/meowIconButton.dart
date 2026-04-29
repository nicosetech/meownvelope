import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';

class MeowIconButton extends StatelessWidget {
  const MeowIconButton({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.onPressed,
    this.horizontalPadding = 0,
    this.verticalPadding = 10,
    this.backgroundColor = MeownvelopeColors.lightBlue,
    this.iconColor = MeownvelopeColors.darkBlue,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double horizontalPadding;
  final double verticalPadding;
  final Color backgroundColor;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      onPressed: onPressed,
      child:Icon(
        icon,
        color: iconColor,
        size: iconSize,
      ),
    );
  }
}