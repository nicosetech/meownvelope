import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/pages/auth_pages/credential_form.dart';
import 'package:meownvelope_mobile/pages/auth_pages/login_page.dart';
import 'package:meownvelope_mobile/pages/auth_pages/authenticaion_widgets.dart';
import 'package:meownvelope_mobile/utils/widgets/meownvelope_app_bar.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/api/credential_api.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meownvelope_mobile/utils/widgets/meowStyledButton.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  CredentialForm credentialForm = CredentialForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MeownvelopeAppBar(titleText: "Create Account"),
      backgroundColor: MeownvelopeColors.bgColor,
      body: SingleChildScrollView(
        child: Align(
          alignment: AlignmentGeometry.topCenter,
          child: Column(
            spacing: 10,
            children: [
              SizedBox(height: 10),
              AuthenticationWidgets.customSizedText(
                "Welcome to Meownvelope!",
                25,
              ),
              AuthenticationWidgets.customSizedText(
                "Let’s get you setup with an account!",
                14,
              ),
              credentialForm,
              MeowStyledButton(
                text: "Create Account",
                horizontalPadding: 20,
                onPressed: () async => requestAccount(),
              ),
              MeowStyledButton(
                text: "Cancel",
                horizontalPadding: 20,
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(height: 10),
              AuthenticationWidgets.linkedText(
                "Already have an account?",
                "Login!",
                () => navToLogin(),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  void requestAccount() async {
    Map<String, String> textFields = credentialForm.getInputFields();
    EasyLoading.show(status: 'Creating...');
    if (textFields.containsKey("username") &&
        textFields.containsKey("email") &&
        textFields.containsKey("password")) {
      ApiReport createStatus = await CredentialApi.createAccount(
        textFields["username"]!,
        textFields["email"]!,
        textFields["password"]!,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(createStatus.message)));
      if (createStatus.result) {
        navToLogin();
      }
    }
    EasyLoading.dismiss();
  }

  void navToLogin() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => LoginPage()),
    );
  }
}
