import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:google_fonts/google_fonts.dart';

// This is reusable Martian Mono text styling which is used across the app.
// These can be adjusted on your own pages, but if you call martion(), it will give these default parameters.

TextStyle martian({
  double fontSize = 14,
  Color color = MeownvelopeColors.darkBlue,
  FontWeight fontWeight = FontWeight.normal,
  double height = 1.5, // controlls spacing between lines of text
  double? letterSpacing,
}) {
  return GoogleFonts.martianMono(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    height: height,
    letterSpacing: letterSpacing,
  );
}