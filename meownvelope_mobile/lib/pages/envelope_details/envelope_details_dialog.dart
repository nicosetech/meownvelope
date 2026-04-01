import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/pages/home_pages/profile/profile_dialog.dart';

void showEditNameDialog(BuildContext context, String currentName, ValueChanged<String> onSave){ 
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
      title: Text(
        'Edit Color',
        style: martian(),
      ),
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
                      color: MeownvelopeColors
                          .darkBlue,
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