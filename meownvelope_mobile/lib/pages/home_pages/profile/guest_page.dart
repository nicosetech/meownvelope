import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/utils/widgets/meowStyledButton.dart';

class GuestPage extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onCreateAccount;

  const GuestPage({
    super.key,
    required this.onLogin,
    required this.onCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Padding(
      // Overall page padding - controls how far from screen edges everything sits
      padding: EdgeInsets.only(left: w * 0.04, right: w * 0.04, top: h * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [

          // ── Buttons Card ──────────────────────────────────────────
          // The faint box that contains the Log In and Create Account buttons
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: w * 0.075, vertical: h * 0.07),
            decoration: BoxDecoration(
              color: MeownvelopeColors.secondaryBgColor,
              borderRadius: BorderRadius.circular(w * 0.04),
            ),
            child: Padding(
              // Extra horizontal padding to make buttons narrower than the card
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ── Log In Button ──
                  SizedBox(
                    width: double.infinity,
                    child: MeowStyledButton(
                      text: 'Log In',
                      onPressed: onLogin,
                      backgroundColor: MeownvelopeColors.lightBlue,
                      textColor: MeownvelopeColors.darkBlue,
                      verticalPadding: h * 0.025,
                    ),
                  ),

                  // ── "or" Divider Text ──
                  SizedBox(height: h * 0.015),
                  Text('or', style: martian(fontSize: w * 0.04, color: MeownvelopeColors.medBlue)),
                  SizedBox(height: h * 0.015),

                  // ── Create Account Button ──
                  SizedBox(
                    width: double.infinity,
                    child: MeowStyledButton(
                      text: 'Create Account',
                      onPressed: onCreateAccount,
                      backgroundColor: MeownvelopeColors.lightBlue,
                      textColor: MeownvelopeColors.darkBlue,
                      verticalPadding: h * 0.025,
                    ),
                  )
                ],
              ),
            ),
          ),

          // ── Spacing between cards ──
          SizedBox(height: h * 0.05),

          // ── Description Card ──────────────────────────────────────
          // The faint box at the bottom explaining why the user should sign in
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.04),
            decoration: BoxDecoration(
              color: MeownvelopeColors.secondaryBgColor,
              borderRadius: BorderRadius.circular(w * 0.04),
            ),
            child: Text(
              'To save information across devices, create an account or log in to a pre-existing account.',
              style: martian(fontSize: w * 0.047, fontWeight: FontWeight.bold, color: MeownvelopeColors.darkBlue, height: 2.0),
              textAlign: TextAlign.center,
            ),
          ),

        ],
      ),
    );
  }
}