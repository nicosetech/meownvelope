import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.01),
        decoration: BoxDecoration(
          color: MeownvelopeColors.lightBlue,
          borderRadius: BorderRadius.circular(w * 0.03),
        ),
        child: Row(
          children: [
            Text(label, style: martian(fontSize: w * 0.06)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: martian(fontSize: w * 0.045, color: MeownvelopeColors.darkBlue),
              ),
            ),
            Icon(Icons.chevron_right, color: MeownvelopeColors.darkBlue, size: w * 0.09),
          ],
        ),
      ),
    );
  }
}