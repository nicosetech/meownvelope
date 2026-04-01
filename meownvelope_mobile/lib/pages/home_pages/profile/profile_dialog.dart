import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/utils/widgets/delete_confirmation_dialog.dart';

const List<String> kPresetAvatarAssets = [
  'assets/avatars/cat1.png',
  'assets/avatars/cat2.png',
  'assets/avatars/cat_default.png',
];

void showLogoutAccountDialog(BuildContext context, VoidCallback onLogout) {
  showDeleteConfirmationDialog(
    context,
    'Logout Account',
    'This action will log you out and track your data locally.',
    'Logout',
    onLogout,
  );
}

void showDeleteAccountDialog(BuildContext context, VoidCallback onDelete) {
  showDeleteConfirmationDialog(
    context,
    'Delete Account',
    'This action is permanent and cannot be undone. All your data will be lost.',
    'Delete',
    onDelete,
  );
}

void showAvatarPicker( 
  BuildContext context,
  int selectedIndex,
  ValueChanged<int> onSelect,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: MeownvelopeColors.bgColor,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Choose a Profile Picture',
              style: martian(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: kPresetAvatarAssets.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12),
            itemBuilder: (ctx, i) {
              final selected = i == selectedIndex;
              return GestureDetector(
                onTap: () {
                  onSelect(i);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? MeownvelopeColors.darkBlue : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: MeownvelopeColors.lightBlue,
                    backgroundImage: AssetImage(kPresetAvatarAssets[i]),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

void showChangeTextDialog(BuildContext context, String title, String hintText, bool obscureText, bool isPassword, ValueChanged<String> onSave, {String initialValue = ''}) {
  final TextEditingController controller = TextEditingController(text: initialValue);
    bool _obscureText = obscureText;
    String _errorText = '';
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: MeownvelopeColors.bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(title, style: martian(fontSize: 16, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                obscureText: _obscureText,
                maxLength: 20,
                style: martian(fontSize: 14),
                onChanged: (val) {
                  if (val.contains(' ')) {
                    controller.text = val.replaceAll(' ', '');
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length),
                    );
                  }
                },
                decoration: InputDecoration(
                  hintText: hintText,
                  counterText: '',
                  hintStyle: martian(fontSize: 14, color: MeownvelopeColors.medBlue),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: MeownvelopeColors.medBlue)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: MeownvelopeColors.darkBlue)),
                  suffixIcon: obscureText ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: MeownvelopeColors.medBlue,
                    ),
                    onPressed: () {
                      setDialogState(() => _obscureText = !_obscureText);
                    },
                  ) : null,
                ),
              ),
              // Error message shows in red below the field
              if (_errorText.isNotEmpty)
                Text(_errorText, style: martian(fontSize: 12, color: MeownvelopeColors.dangerRed)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: martian(color: MeownvelopeColors.medBlue)),
            ),
            TextButton(
              onPressed: () {
                final val = controller.text.trim();
                if (isPassword) {
                  if (val.length < 6) {
                    setDialogState(() => _errorText = 'Password must be at least 6 characters.');
                    return;
                  }
                }
                  else {
                    if (val.isEmpty) {
                      setDialogState(() => _errorText = 'Please enter a username.');
                      return;
                    }
                  }
                onSave(val);
                Navigator.pop(context);
              },
              child: Text('Save', style: martian(color: MeownvelopeColors.darkBlue)),
            ),
          ],
        ),
      ),
    );
}
  

void showChangeUsernameDialog(BuildContext context, ValueChanged<String> onSave){
  showChangeTextDialog(
    context,
    'Change Username',
    'username',
    false,
    false,
    onSave,
  );
}

void showChangePasswordDialog(BuildContext context, ValueChanged<String> onSave){
  showChangeTextDialog(
    context,
    'Change Password',
    'Enter new password',
    true,
    true,
    onSave,
  );
}