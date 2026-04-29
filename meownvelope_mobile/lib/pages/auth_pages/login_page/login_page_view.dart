import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meownvelope_mobile/pages/auth_pages/create_page/create_account_page_view_model.dart';
import 'package:meownvelope_mobile/pages/auth_pages/login_page/login_page_view_model.dart';
import 'package:meownvelope_mobile/pages/auth_pages/create_page/create_account_page_view.dart';
import 'package:meownvelope_mobile/pages/auth_pages/credential_form/credential_form_view.dart';
import 'package:meownvelope_mobile/pages/auth_pages/authenticaion_widgets.dart';
import 'package:meownvelope_mobile/utils/widgets/meownvelope_app_bar.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/widgets/meowStyledButton.dart';
import 'package:provider/provider.dart';

class LoginPageView extends StatelessWidget {
  const LoginPageView({super.key, required this.viewModel});

  final LoginPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: const _LoginPage(),
    );
  }
}

class _LoginPage extends StatelessWidget {
  const _LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginPageViewModel>();

    if (viewModel.loginState == LoginState.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.popUntil(context, (route) => route.isFirst);
      });
    }

    if (viewModel.loginState == LoginState.error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              viewModel.errorMessage ?? "An error occurred during login.",
            ),
          ),
        );
      });
    }

    if (viewModel.loginState == LoginState.loading) {
      EasyLoading.show(status: "Logging in...");
    } else {
      EasyLoading.dismiss();
    }

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
              CredentialFormView(viewModel: viewModel.credentialFormModel),
              MeowStyledButton(
                text: "Login",
                horizontalPadding: 60,
                onPressed: () async => viewModel.requestLogin(),
              ),
              MeowStyledButton(
                text: "Cancel",
                horizontalPadding: 20,
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              ),
              SizedBox(height: 10),
              // linkedText(null, "Forgot Password?"),
              AuthenticationWidgets.linkedText(
                "Don't have an account?",
                "Create one here!",
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => CreateAccountPageView(viewModel: CreateAccountPageViewModel()),
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
}
