import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';

class LabeledRadioOption extends StatelessWidget {
  final String label;
  final bool value;
  final bool groupValue;
  final Color activeColor;
  final ValueChanged<bool?> onChanged;

  const LabeledRadioOption({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.8,
          child: Radio<bool>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: activeColor,
            fillColor: MaterialStateProperty.all(activeColor),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label, style: martian(
            fontSize: 17,
            color: activeColor,
            fontWeight: FontWeight.w600,
            height: 1.8,
          )),
        ),
      ],
    );
  }
}