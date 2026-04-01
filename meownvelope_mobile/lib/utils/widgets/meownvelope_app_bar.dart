import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';

class MeownvelopeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MeownvelopeAppBar({super.key, required this.titleText});

  final String titleText;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MeownvelopeColors.bgColor,
      titleSpacing: 0,
      title: FittedBox(
        fit: BoxFit.fill,
        child: Padding(
          padding: const EdgeInsets.only(right: 30),
          child: Text(
            titleText,
            style: GoogleFonts.mochiyPopPOne(
              textStyle: TextStyle(fontSize: 35),
            ),
          ),
        ),
      ),
      leadingWidth: 90,
      leading: Image.asset(
        'assets/cat_paw.png',
        color: MeownvelopeColors.darkBlue,
      ),
      foregroundColor: MeownvelopeColors.darkBlue,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
