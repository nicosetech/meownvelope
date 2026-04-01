import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';

void showDeleteConfirmationDialog(BuildContext context, String title, String content, String confirmText, VoidCallback onDelete) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog (
        backgroundColor: MeownvelopeColors.bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: martian(fontSize: 16, fontWeight: FontWeight.bold, color: MeownvelopeColors.dangerRed)),
        content: Text(
          content,
          style: martian(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: martian(color: MeownvelopeColors.medBlue)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: Text(confirmText, style: martian(color: MeownvelopeColors.dangerRed)),
          ),
        ]
      ),
    );
}