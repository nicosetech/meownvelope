import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';

class EnvelopePreview extends StatelessWidget {
  final Color color;
  final String label;
  final double width;
  final double height;
  final double fontSize;


  const EnvelopePreview({
    super.key,
    required this.color,
    required this.label,
    required this.width,
    required this.height,
    this.fontSize = 16,
  });

  @override 
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/envelope.png',
            fit: BoxFit.fill,
            width: double.infinity,
            height: height,
          ),
          Positioned(  
            bottom: height * 0.75,
            child: Text( 
              label,
              style: martian(
                fontSize: fontSize,
                color: MeownvelopeColors.darkBlue,
              )
            )
          )
        ],
      ),
    );

  }
}