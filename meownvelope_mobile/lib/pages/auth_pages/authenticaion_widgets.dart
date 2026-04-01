import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/widgets/meowStyledButton.dart';

class AuthenticationWidgets {
  static Widget customSizedText(String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FittedBox(
        child: Text(
          text,
          style: GoogleFonts.mochiyPopPOne(
            textStyle: TextStyle(
              fontSize: fontSize,
              color: MeownvelopeColors.darkBlue,
            ),
          ),
        ),
      ),
    );
  }

  static Widget linkedText(
    String? regularText,
    String buttonText,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: MeownvelopeColors.secondaryBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.only(
        left: 25,
        right: 25,
        top: regularText != null ? 10 : 0,
      ),
      child: Column(
        children: [
          regularText != null
              ? Text(regularText, style: linkedTextStyle())
              : SizedBox(),
          TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
            ),
            child: Text(buttonText, style: linkedTextStyle(underline: true)),
          ),
        ],
      ),
    );
  }

  static TextStyle linkedTextStyle({bool underline = false}) {
    return GoogleFonts.mochiyPopOne(
      color: MeownvelopeColors.iconColor,
      fontSize: 12,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
    );
  }
}