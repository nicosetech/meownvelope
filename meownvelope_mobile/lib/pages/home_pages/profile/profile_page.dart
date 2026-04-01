import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/pages/home_pages/abstract_home_page.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/pages/home_pages/profile/guest_page.dart';
import 'package:meownvelope_mobile/pages/home_pages/profile/profile_dialog.dart';
import 'package:meownvelope_mobile/pages/auth_pages/login_page.dart';
import 'package:meownvelope_mobile/pages/auth_pages/create_account_page.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';
import 'package:meownvelope_mobile/utils/api/credential_api.dart';
import 'package:meownvelope_mobile/utils/widgets/profile_info_row.dart';

class ProfilePage extends AbstractHomePage {
  const ProfilePage({super.key});

  @override
  IconData getIcon() {
    return Icons.person;
  }

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoggedIn = false;
  String _username = 'user_name';
  String _password = '••••••••';
  int _selectedAvatarIndex = -1;

  @override 
  void initState() {
    super.initState();
    _isLoggedIn = HiveDatabase.getUserData().get("username") != null;
    if (_isLoggedIn) {
      _username = HiveDatabase.getUserData().get("username");
    _selectedAvatarIndex = HiveDatabase.getUserData().get("avatarIndex", defaultValue: -1);
    }
  }

  Widget _buildLoggedIn() {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SizedBox.expand(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // - Avatar Section 
            // Tappable avatar, opens picker on tap
            GestureDetector(
              onTap: () => showAvatarPicker(context, _selectedAvatarIndex, (i) {
                HiveDatabase.getUserData().put("avatarIndex", i);
                setState(() => _selectedAvatarIndex = i);
              }),
              child: SizedBox(
                width: w * 0.5,
                height: w * 0.5,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: w * 0.25,
                      backgroundColor: MeownvelopeColors.lightBlue,
                      backgroundImage: _selectedAvatarIndex == -1
                          ? const AssetImage('assets/avatars/cat_default.png')
                          : AssetImage(kPresetAvatarAssets[_selectedAvatarIndex]),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: () => showAvatarPicker(context, _selectedAvatarIndex, (i) => setState(() => _selectedAvatarIndex = i)),
                        child: Container(
                          width: w * 0.08,
                          height: w * 0.08,
                          decoration: BoxDecoration(
                            color: MeownvelopeColors.darkBlue,
                            shape: BoxShape.circle,
                            border: Border.all(color: MeownvelopeColors.bgColor, width: 2),
                          ),
                          child: Icon(Icons.edit, color: Colors.white, size: w * 0.04),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: h * 0.07),
            // - Username
            // Tappable row showing username, chevron navigates to change username page
            ProfileInfoRow( 
              label: 'Username:',
              value: _username,
              onTap: () => showChangeUsernameDialog(context, (val) async{
                final userData = HiveDatabase.getUserData();
                final username = userData.get("username");
                final password = userData.get("password");
                ApiReport result = await CredentialApi.changeUsername(username, password, val);
                if (result.result) {
                  userData.put("username", val);
                  setState(() => _username = val);
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message)));
              }),
              ),
            SizedBox(height: h * 0.012),
      
            // ─ Password 
            // Tappable row showing masked password, chevron navigates to change password page
            ProfileInfoRow( 
              label: 'Password:',
              value: _password,
              onTap: () => showChangePasswordDialog(context, (val) async{
                final userData = HiveDatabase.getUserData();
                final username = userData.get("username");
                final password = userData.get("password");
                ApiReport result = await CredentialApi.changePassword(username, password, val);
                if (result.result) {
                  userData.put("password", val);
                  setState(() => _password = '••••••••');
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message)));
              }),
            ),
            Spacer(),
      
            // ─ Log Out Button 
            // Tappable row with logout icon, triggers confirmation dialog
            GestureDetector(
              onTap: () => showLogoutAccountDialog(context, () {
                HiveDatabase.getUserData().delete("username");
                HiveDatabase.getUserData().delete("password");
                setState(() => _isLoggedIn = false);
              }),
              child: Row(
                children: [
                  Icon(Icons.exit_to_app, color: MeownvelopeColors.darkBlue, size: w * 0.075),
                  const SizedBox(width: 10),
                  Text('Log out', style: martian(fontSize: w * 0.065)),
                ],
              ),
            ),
            SizedBox(height: h * 0.02),
      
            // ─ Delete Button 
            // Tappable row with delete icon, triggers warning dialog
            GestureDetector(
              onTap: () => showDeleteAccountDialog(context, () async {
                final userData = HiveDatabase.getUserData();
                final username = userData.get("username");
                final password = userData.get("password");
                ApiReport result = await CredentialApi.deleteAccount(username, password);
                if (result.result) {
                  userData.delete("username");
                  userData.delete("password");
                  setState(() => _isLoggedIn = false);
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message)),
              );
              }),
              child: Row(
                children: [
                  Icon(Icons.delete_forever_outlined, color: MeownvelopeColors.darkBlue, size: w * 0.075),
                  const SizedBox(width: 10),
                  Text('Delete account', style: martian(fontSize: w * 0.065)),
                ],
              ),
            ),
      
          ],
        ),
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: MeownvelopeColors.bgColor,
      child: SafeArea(
        child: _isLoggedIn 
          ? _buildLoggedIn() 
          : GuestPage( 
            onLogin: () {
              Navigator.push( 
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                ).then((_) {
                  setState(() {
                    _isLoggedIn = HiveDatabase.getUserData().get("username") != null;
                    if (_isLoggedIn) {
                      _username = HiveDatabase.getUserData().get("username");
                    }
                  });
                });
            },
            onCreateAccount: () {
              Navigator.push( 
                context,
                MaterialPageRoute(builder: (_) => const CreateAccountPage()),
              ).then((_) {
                setState(() {
                  _isLoggedIn = HiveDatabase.getUserData().get("username") != null;
                  if (_isLoggedIn) {
                    _username = HiveDatabase.getUserData().get("username");
                  }
                });
              });
            },
          ),
        ),
    );
  }
}


