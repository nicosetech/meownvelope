import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:meownvelope_mobile/pages/auth_pages/authenticaion_widgets.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/widgets/meowStyledButton.dart';

class PopupNotifier extends StatelessWidget {
  const PopupNotifier({super.key, required this.title, required this.info});

  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MeownvelopeColors.iconColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.mochiyPopPOne(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 15),
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: MeownvelopeColors.darkBlue,
              ),
            ),
          ),
          Text(
            info,
            textAlign: TextAlign.center,
            style: GoogleFonts.mochiyPopPOne(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20,),
          MeowStyledButton(text: "Okay", onPressed: () => Navigator.pop(context),backgroundColor: MeownvelopeColors.darkBlue,textColor: Colors.white,)
        ],
      ),
    );
  }

  static void displayPopup(BuildContext context, String title, String info) {
    showDialog(
      context: context,
      builder: (context) {
        return PopupNotifier(title: title, info: info);
      },
    );
  }
}
