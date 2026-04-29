import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/data/services/api/api_tools.dart';
import 'package:meownvelope_mobile/pages/auth_pages/create_page/create_account_page_view_model.dart';
import 'package:meownvelope_mobile/pages/auth_pages/login_page/login_page_view.dart';
import 'package:meownvelope_mobile/pages/auth_pages/login_page/login_page_view_model.dart';
import 'package:meownvelope_mobile/pages/home_pages/abstract_home_page.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/pages/home_pages/profile/guest_page.dart';
import 'package:meownvelope_mobile/pages/home_pages/profile/profile_dialog.dart';
import 'package:meownvelope_mobile/pages/auth_pages/create_page/create_account_page_view.dart';
import 'package:meownvelope_mobile/utils/widgets/profile_info_row.dart';
import 'package:meownvelope_mobile/pages/home_pages/profile/profile_page_view_model.dart';

class ProfilePageView extends AbstractHomePage {
  const ProfilePageView({super.key});

  @override
  IconData getIcon() {
    return Icons.person;
  }

  @override
  State<ProfilePageView> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageView> {

  final _viewModel = ProfilePageViewModel();

  @override 
  void initState() {
    super.initState();
    _viewModel.loadUserData();
    _viewModel.addListener(() => setState(() {}));
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
              onTap: () => showAvatarPicker(context, _viewModel.selectedAvatarIndex, (i) async {
                await _viewModel.handleAvatarChange(i);
              }),
              child: SizedBox(
                width: w * 0.5,
                height: w * 0.5,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: w * 0.25,
                      backgroundColor: MeownvelopeColors.lightBlue,
                      backgroundImage: _viewModel.selectedAvatarIndex == -1
                          ? const AssetImage('assets/avatars/cat_default.png')
                          : AssetImage(kPresetAvatarAssets[_viewModel.selectedAvatarIndex]),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: () => showAvatarPicker(context, _viewModel.selectedAvatarIndex, (i) async => await _viewModel.handleAvatarChange(i)),
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
              value: _viewModel.username,
              onTap: () => showChangeUsernameDialog(context, (val) async{
                ApiReport result = await _viewModel.handleChangeUsername(val);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message)));
              }),
            ),
            SizedBox(height: h * 0.012),
      
            // ─ Password 
            // Tappable row showing masked password, chevron navigates to change password page
            ProfileInfoRow( 
              label: 'Password:',
              value: '••••••••',
              onTap: () => showChangePasswordDialog(context, (val) async{
                ApiReport result = await _viewModel.handleChangePassword(val);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message)));
              }),
            ),
            Spacer(),
      
            // ─ Log Out Button 
            // Tappable row with logout icon, triggers confirmation dialog
            GestureDetector(
              onTap: () => showLogoutAccountDialog(context, () async{
                await _viewModel.handleLogout();
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
                await _viewModel.handleDeleteAccount();
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
        child: _viewModel.isLoggedIn 
          ? _buildLoggedIn() 
          : GuestPage( 
            onLogin: () {
              Navigator.push( 
                context,
                MaterialPageRoute(builder: (_) => LoginPageView(viewModel: LoginPageViewModel(),)),
                ).then((_) => _viewModel.handleLoginSuccess());
            },
            onCreateAccount: () {
              Navigator.push( 
                context,
                MaterialPageRoute(builder: (_) => CreateAccountPageView(viewModel: CreateAccountPageViewModel(),)),
              ).then((_) => _viewModel.handleLoginSuccess());
            },
          ),
        ),
    );
  }
}


