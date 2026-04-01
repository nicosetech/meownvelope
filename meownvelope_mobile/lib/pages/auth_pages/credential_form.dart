import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meownvelope_mobile/utils/styling/custom_icons.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';

class CredentialForm extends StatefulWidget {
  CredentialForm({super.key, this.includeEmail = true});

  final bool includeEmail;
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Map<String, String> getInputFields() {
    final bool isValid = formKey.currentState?.validate() ?? false;
    if (isValid) {
      return {
        "username": usernameController.text,
        "email": emailController.text,
        "password": passwordController.text,
      };
    }
    return {};
  }

  @override
  State<CredentialForm> createState() => _CredentialFormState();
}

class _CredentialFormState extends State<CredentialForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: MeownvelopeColors.secondaryBgColor,
        ),
        padding: EdgeInsets.all(25),
        child: Form(
          key: widget.formKey,
          child: Column(
            spacing: widget.includeEmail ? 30 : 15,

            children: [
              inputField(
                CustomIcons.profile,
                "Username",
                widget.usernameController,
                usernameValidator,
              ),
              widget.includeEmail
                  ? inputField(
                      CustomIcons.envelope,
                      "E-mail",
                      widget.emailController,
                      emailValidator,
                    )
                  : SizedBox(),
              inputField(
                CustomIcons.lock,
                "Password",
                widget.passwordController,
                passwordValidator,
                isPassword: true,
              ),
            ],
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

  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length != value.replaceAll(' ', '').length) {
      return 'Must not contain any spaces';
    }
    if (int.tryParse(value[0]) != null) {
      return 'Must not start with a number';
    }
    if (value.length <= 2) {
      return 'Must be at least 3 characters';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length <= 2) {
      return 'Password should be at least 3 characters long';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!value.contains("@")) {
      return 'Email must be valid';
    }
    return null;
  }
}
