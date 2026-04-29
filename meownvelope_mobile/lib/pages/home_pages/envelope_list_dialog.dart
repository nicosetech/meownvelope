import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meownvelope_mobile/utils/widgets/meowStyledButton.dart';
import 'package:pinput/pinput.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/pages/home_pages/envelope_list_view_model.dart';

void showEnvelopeCodeDialog(BuildContext context, double w, double h, EnvelopeListViewModel viewModel) {
  final TextEditingController controller = TextEditingController();

  final defaultPinTheme = PinTheme( 
    width: w * 0.09,
    height: h * 0.06,
    textStyle: martian(fontSize: w*0.04, color: MeownvelopeColors.darkBlue),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
  );

  showDialog(  
    context: context,
    builder: (context) => AlertDialog( 
      backgroundColor: MeownvelopeColors.medBlue,
      contentPadding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.02),
      title: Text(
        "Input your furiend's envelope code:",
        style: martian(fontSize: w * 0.04, color: MeownvelopeColors.darkBlue),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          height: h * 0.12,
          child: Pinput(  
            controller: controller,
            length: 8,
            defaultPinTheme: defaultPinTheme,
            keyboardType: TextInputType.text,
            // Will allow numbers and capital letters
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            ],
          ),
        ),
      ),
      actions: [
          MeowStyledButton(
            text: "Ok",
            onPressed: () {
              Navigator.of(context).pop();
              viewModel.handleCodeSubmit(controller.text);
            },
            backgroundColor: MeownvelopeColors.darkBlue,
            textColor: Colors.white,
            verticalPadding: h * 0.015,
          )
        ],
    ),
  );
}