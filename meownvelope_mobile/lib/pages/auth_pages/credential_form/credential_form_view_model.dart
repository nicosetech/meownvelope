import 'package:flutter/material.dart';

class CredentialFormViewModel extends ChangeNotifier{
  CredentialFormViewModel({this.includeEmail = true});

  final bool includeEmail;
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get emailController => _emailController;  
  TextEditingController get passwordController => _passwordController;


  Map<String, String> getInputFields() {
    final bool isValid = formKey.currentState?.validate() ?? false;
    if (isValid) {
      return {
        "username": _usernameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
      };
    }
    return {};
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!value.contains("@")) {
      return 'Email must be valid';
    }
    if (!value.endsWith(".com") && !value.endsWith(".net") && !value.endsWith(".org")) {
      return 'Email must be valid';
    }
    if (value.contains(' ')) {
      return 'Email must be valid';
    }
    if (value.indexOf("@") != value.lastIndexOf("@")) {
      return 'Email must be valid';
    }
    if (value.length < 6) {
      return 'Email must be valid';
    }
    return null;
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
    if (value.length < 3) {
      return 'Must be at least 3 characters';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length < 6) {
      return 'Password is too short';
    }
    return null;
  }
}