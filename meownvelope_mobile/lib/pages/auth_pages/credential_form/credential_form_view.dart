import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meownvelope_mobile/pages/auth_pages/credential_form/credential_form_view_model.dart';
import 'package:meownvelope_mobile/utils/styling/custom_icons.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:provider/provider.dart';

class CredentialFormView extends StatelessWidget {
  CredentialFormView({super.key, required this.viewModel});

  final CredentialFormViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: MeownvelopeColors.secondaryBgColor,
        ),
        padding: EdgeInsets.all(25),
        child: ChangeNotifierProvider.value(
          value: viewModel,
          child: Form(
            key: viewModel.formKey,
            child: Column(
              spacing: viewModel.includeEmail ? 30 : 15,
          
              children: [
                inputField(
                  CustomIcons.profile,
                  "Username",
                  viewModel.usernameController,
                  viewModel.usernameValidator,
                ),
                viewModel.includeEmail
                    ? inputField(
                        CustomIcons.envelope,
                        "E-mail",
                        viewModel.emailController,
                        viewModel.emailValidator,
                      )
                    : SizedBox(),
                inputField(
                  CustomIcons.lock,
                  "Password",
                  viewModel.passwordController,
                  viewModel.passwordValidator,
                  isPassword: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField(
    IconData iconData,
    String hintText,
    TextEditingController controller,
    FormFieldValidator<String?> validator, {
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: MeownvelopeColors.lightBlue,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(iconData, color: MeownvelopeColors.iconColor, size: 40),
          border: InputBorder.none,
          fillColor: MeownvelopeColors.lightBlue,
          filled: true,
          hintText: hintText,
          hintStyle: GoogleFonts.martianMono(
            color: Colors.blueGrey,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
          ),
        ),
        validator: validator,
        cursorColor: MeownvelopeColors.darkBlue,
        style: GoogleFonts.mochiyPopPOne(color: Colors.black, fontSize: 15),
        obscureText: isPassword,
        enableSuggestions: !isPassword,
        autocorrect: !isPassword,
      ),
    );
  }
}
