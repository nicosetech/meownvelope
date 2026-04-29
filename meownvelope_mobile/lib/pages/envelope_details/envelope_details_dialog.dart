import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/pages/home_pages/profile/profile_dialog.dart';
import 'package:meownvelope_mobile/utils/widgets/meowStyledButton.dart';
import 'package:clipboard/clipboard.dart';

void showEditNameDialog(
  BuildContext context,
  String currentName,
  ValueChanged<String> onSave,
) {
  showChangeTextDialog(
    context,
    'Edit Name',
    'Envelope name',
    false,
    false,
    onSave,
    initialValue: currentName,
  );
}

void showEditColorDialog(BuildContext context, ValueChanged<int> onSave) {
  final w = MediaQuery.of(context).size.width;
  final h = MediaQuery.of(context).size.height;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: MeownvelopeColors.bgColor,
      title: Text('Edit Color', style: martian()),
      content: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: MeownvelopeColors.presetEnvelopeColors
            .map(
              (color) => GestureDetector(
                onTap: () async {
                  onSave(color.value);
                  Navigator.pop(context);
                },
                child: Container(
                  width: w * 0.1,
                  height: h * 0.1,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: MeownvelopeColors.darkBlue,
                      width: 1,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ),
  );
}

void showLockedCloudDialog(BuildContext context, double w) {
  final h = MediaQuery.of(context).size.height;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: MeownvelopeColors.lightBlue,
      title: Text(
        "You must be logged in to share envelopes.",
        style: martian(fontSize: w * 0.05),
      ),
      actions: [
        MeowStyledButton(
          text: "Ok",
          onPressed: () => Navigator.of(context).pop(),
          backgroundColor: MeownvelopeColors.darkBlue,
          textColor: Colors.white,
          verticalPadding: h * 0.015,
        ),
      ],
    ),
  );
}

void showUploadedCloudDialog(
  BuildContext context,
  double w,
  VoidCallback onConfirm,
) {
  final h = MediaQuery.of(context).size.height;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: MeownvelopeColors.lightBlue,
      title: Text("Generate a share code?", style: martian(fontSize: w * 0.05)),
      content: Text(
        "Share the code with a friend to invite them to your envelope.",
        style: martian(fontSize: w * 0.04),
      ),
      actions: [
        MeowStyledButton(
          text: "Get Code",
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          backgroundColor: MeownvelopeColors.darkBlue,
          textColor: Colors.white,
          verticalPadding: h * 0.015,
        ),
        MeowStyledButton(
          text: "Cancel",
          onPressed: () => Navigator.of(context).pop(),
          backgroundColor: MeownvelopeColors.darkBlue,
          textColor: Colors.white,
          verticalPadding: h * 0.015,
        ),
      ],
    ),
  );
}

void showUploadEnvelopeDialog(
  BuildContext context,
  double w,
  VoidCallback onConfirm,
) {
  final h = MediaQuery.of(context).size.height;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: MeownvelopeColors.lightBlue,
      title: Text(
        "Upload envelope to server?",
        style: martian(fontSize: w * 0.05),
      ),
      content: Text(
        "This will allow you to share this envelope with other users.",
        style: martian(fontSize: w * 0.04),
      ),
      actions: [
        MeowStyledButton(
          text: "Cancel",
          onPressed: () => Navigator.of(context).pop(),
          backgroundColor: MeownvelopeColors.darkBlue,
          textColor: Colors.white,
          verticalPadding: h * 0.015,
        ),
        MeowStyledButton(
          text: "Upload",
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          backgroundColor: MeownvelopeColors.darkBlue,
          textColor: Colors.white,
          verticalPadding: h * 0.015,
        ),
      ],
    ),
  );
}

void showShareCode(BuildContext context, double w, String shareCode) async {
  final h = MediaQuery.of(context).size.height;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: MeownvelopeColors.lightBlue,
      title: Text("You share code is...", style: martian(fontSize: w * 0.05)),
      content: Text(shareCode, style: martian(fontSize: w * 0.04)),
      actions: [
        MeowStyledButton(
          text: "Copy",
          onPressed: () async {
            await FlutterClipboard.copy(shareCode);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Copied!')));
          },
          backgroundColor: MeownvelopeColors.darkBlue,
          textColor: Colors.white,
          verticalPadding: h * 0.015,
        ),

        MeowStyledButton(
          text: "Dismiss",
          onPressed: () => Navigator.of(context).pop(),
          backgroundColor: MeownvelopeColors.darkBlue,
          textColor: Colors.white,
          verticalPadding: h * 0.015,
        ),
      ],
    ),
  );
}
