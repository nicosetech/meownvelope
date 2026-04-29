import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:meownvelope_mobile/data/services/api/api_tools.dart';
import 'package:meownvelope_mobile/data/services/api/credential_api.dart';

void main() {
  group("credential api test suite", (){
    final String username = getRandomString(17);
    final String email = "${getRandomString(17)}@gmail.com";
    final String password = getRandomString(20);
    
    //Create account tests
    group('createAccount tests', () {
      test('Should create a new account with valid credentials', () async {
        final ApiReport result = await CredentialApi.createAccount(username, email, password);
        expect(result.result, true);
      });

      test('Should fail to create an account with previously used username', () async {
        final ApiReport result = await CredentialApi.createAccount(username, "new$email", password);
        expect(result.result, false);
      });

      test('Should fail to create an account with previously used email', () async {
        final ApiReport result = await CredentialApi.createAccount("new$username", email, password);
        expect(result.result, false);
      });
    });

    //Login account tests
    group('loginToAccount tests', () {
      test("Should log in to an existing account with valid credentials", () async{
        final ApiReport result = await CredentialApi.loginToAccount(username, password);
        expect(result.result, true);
      });

      test("Should fail to log in with invalid username", () async{
        final ApiReport result = await CredentialApi.loginToAccount("bad$username", password);
        expect(result.result, false);
      });

      test("Should fail to log in with invalid password", () async{
        final ApiReport result = await CredentialApi.loginToAccount(username, "bad$password");
        expect(result.result, false);
      });

      test("Should fail to log in with invalid credentials", () async{
        final ApiReport result = await CredentialApi.loginToAccount("bad$username", "bad$password");
        expect(result.result, false);
      });
    });

    //Test changeUsername
    group('changeUsername tests', () {
      test("Should change username with valid credentials", () async{
        final ApiReport result = await CredentialApi.changeUsername(username, password, "new$username");
        expect(result.result, true);
      });
      test("Should fail to login with old username", () async{
        final ApiReport result = await CredentialApi.loginToAccount(username, password);
        expect(result.result, false);
      });
      test("Should succeed to login with new username", () async{
        final ApiReport result = await CredentialApi.loginToAccount("new$username", password);
        expect(result.result, true);
      });
      test("Should return username to original", () async{
        final ApiReport result = await CredentialApi.changeUsername("new$username", password, username);
        expect(result.result, true);
      });
    });

    //Test changePassword
    group('changePassword tests', () {
      test("Should change password with valid credentials", () async{
        final ApiReport result = await CredentialApi.changePassword(username, password, "new$password");
        expect(result.result, true);
      });
      test("Should fail to login with old password", () async{
        final ApiReport result = await CredentialApi.loginToAccount(username, password);
        expect(result.result, false);
      });
      test("Should succeed to login with new password", () async{
        final ApiReport result = await CredentialApi.loginToAccount(username, "new$password");
        expect(result.result, true);
      });
      test("Should return password to original", () async{
        final ApiReport result = await CredentialApi.changePassword(username, "new$password", password);
        expect(result.result, true);
      });
    });

    //Test deleteAccount
    group('deleteAccount tests', () {
      test('Should fail to delete account with invalid credentials', () async {
        final ApiReport result = await CredentialApi.deleteAccount(username, "bad$password");
        expect(result.result, false);
      });

      test('Should delete an existing account', () async {
        final ApiReport result = await CredentialApi.deleteAccount(username, password);
        expect(result.result, true);
      });

      test("Should fail to login to deleted account", () async{
        final ApiReport result = await CredentialApi.loginToAccount(username, password);
        expect(result.result, false);
      });
    });
  });
}


String getRandomString(int length){
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  return String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
} 

