import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';

class MeowStyledButton extends StatelessWidget {
  MeowStyledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.horizontalPadding = 15,
    this.verticalPadding = 15,
    this.backgroundColor = MeownvelopeColors.iconColor,
    this.textColor = Colors.white,
  });

  final String text;
  final VoidCallback onPressed;
  final double horizontalPadding;
  final double verticalPadding;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
        padding: WidgetStatePropertyAll(
          EdgeInsetsGeometry.symmetric(
            horizontal: horizontalPadding,
            vertical: 15,
          ),
        ),
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.martianMono(
          fontWeight: FontWeight.bold,
          color: textColor,
          fontSize: 17,
        ),
      ),
    );
  }
}
