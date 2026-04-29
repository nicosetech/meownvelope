import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meownvelope_mobile/pages/auth_pages/create_page/create_account_page_view_model.dart';
import 'package:meownvelope_mobile/pages/auth_pages/credential_form/credential_form_view.dart';
import 'package:meownvelope_mobile/pages/auth_pages/authenticaion_widgets.dart';
import 'package:meownvelope_mobile/pages/auth_pages/login_page/login_page_view.dart';
import 'package:meownvelope_mobile/pages/auth_pages/login_page/login_page_view_model.dart';
import 'package:meownvelope_mobile/utils/widgets/meownvelope_app_bar.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/widgets/meowStyledButton.dart';
import 'package:provider/provider.dart';

class CreateAccountPageView extends StatelessWidget {
  const CreateAccountPageView({super.key, required this.viewModel});

  final CreateAccountPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: const _CreateAccountPageView(),
    );
  }
}

class _CreateAccountPageView extends StatelessWidget {
  const _CreateAccountPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreateAccountPageViewModel>();

    print("THINGS HAPPENIONG LOL");
    if (viewModel.createAccountState == CreateAccountState.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) =>
                LoginPageView(viewModel: LoginPageViewModel()),
          ),
        );
      });
    }

    if (viewModel.createAccountState == CreateAccountState.error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              viewModel.errorMessage ??
                  "An error occurred during account creation.",
            ),
          ),
        );
      });
    }

    if (viewModel.createAccountState == CreateAccountState.loading) {
      EasyLoading.show(status: "Creating Account...");
    } else {
      EasyLoading.dismiss();
    }

    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Scaffold(
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
                CredentialFormView(viewModel: viewModel.credentialFormModel),
                MeowStyledButton(
                  text: "Create Account",
                  horizontalPadding: 20,
                  onPressed: () async => viewModel.requestAccount(),
                ),
                MeowStyledButton(
                  text: "Cancel",
                  horizontalPadding: 20,
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                ),
                SizedBox(height: 10),
                AuthenticationWidgets.linkedText(
                  "Already have an account?",
                  "Login!",
                  () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) =>
                          LoginPageView(viewModel: LoginPageViewModel()),
                    ),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
