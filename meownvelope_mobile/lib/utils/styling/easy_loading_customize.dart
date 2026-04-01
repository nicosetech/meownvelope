import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';

class EasyLoadingCustomize {
  static TransitionBuilder initCustomEasyLoading({TransitionBuilder? builder}) {
    return (BuildContext context, Widget? child) {
      EasyLoading.instance
        ..indicatorType = EasyLoadingIndicatorType.fadingCircle
        ..loadingStyle = EasyLoadingStyle.custom
        ..indicatorSize = 35.0
        ..radius = 10.0
        ..backgroundColor = MeownvelopeColors.iconColor
        ..indicatorColor = Colors.white
        ..textColor = Colors.white
        ..textStyle = GoogleFonts.mochiyPopPOne(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        )
        ..userInteractions = false
        ..maskType = EasyLoadingMaskType.black;

      return FlutterEasyLoading(child: child);
    };
  }
}
