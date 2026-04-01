import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meownvelope_mobile/pages/auth_pages/create_account_page.dart';
import 'package:meownvelope_mobile/pages/auth_pages/credential_form.dart';
import 'package:meownvelope_mobile/pages/auth_pages/authenticaion_widgets.dart';
import 'package:meownvelope_mobile/utils/widgets/meownvelope_app_bar.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/api/credential_api.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';
import 'package:meownvelope_mobile/utils/widgets/meowStyledButton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  CredentialForm credentialForm = CredentialForm(includeEmail: false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MeownvelopeColors.bgColor,
      appBar: const MeownvelopeAppBar(titleText: "Login To Account"),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20,
            children: [
              SizedBox(height: 10),
              AuthenticationWidgets.customSizedText("Welcome back!", 25),
              AuthenticationWidgets.customSizedText(
                "Login to access your online envelopes!",
                14,
              ),
              credentialForm,
              MeowStyledButton(
                text:"Login",
                horizontalPadding :60,
                onPressed: () async => requestLogin(),
              ),
              MeowStyledButton(
                text: "Cancel",
                horizontalPadding: 20,
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(height: 10),
              // linkedText(null, "Forgot Password?"),
              AuthenticationWidgets.linkedText(
                "Don't have an account?",
                "Create one here!",
                () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => CreateAccountPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void requestLogin() async {
    Map<String, String> textFields = credentialForm.getInputFields();
    EasyLoading.show(status: 'Logging In...');
    if (textFields.containsKey("username") &&
        textFields.containsKey("password")) {
      ApiReport createStatus = await CredentialApi.loginToAccount(
        textFields["username"]!,
        textFields["password"]!,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(createStatus.message)));
      if (createStatus.result) {
        HiveDatabase.addLoginData(
          textFields["username"]!,
          textFields["password"]!,
        );
        Navigator.pop(context);
      }
    }
    EasyLoading.dismiss();
  }
}
