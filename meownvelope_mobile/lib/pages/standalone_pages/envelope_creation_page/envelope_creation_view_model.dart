import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/data/repositories/badge_repository.dart';
import 'package:meownvelope_mobile/data/repositories/envelope_repository.dart';

class EnvelopeCreationViewModel extends ChangeNotifier {
  Color selectedColor = const Color(0xFFFFFFFF);
  bool placeAtStart = true;

  void handleColorSelect(Color color) {
    selectedColor = color;
    notifyListeners();
  }

  void handlePlacementChange(bool value) {
    placeAtStart = value;
    notifyListeners();
  }

  Future<String?> validateAndCreate(String name, String goalText) async {
    if (name.isEmpty) return 'Please enter an envelope name';
    if (name.length > 20) return 'Name must be 20 characters or less';
    if (goalText.isEmpty) return 'Please enter a goal amount';
    double? goal = double.tryParse(goalText);
    if (goal == null) return 'Please enter a valid number for the goal';
    if ( goal <= 0) return 'Goal must be greater than 0';

    await EnvelopeRepository.newEnvelope(name, selectedColor.value, goal, 0.0, await EnvelopeRepository.envelopeOrder(placeAtStart),);

    await BadgeRepository.checkEnvelopeBadges(EnvelopeRepository.getEnvelopes().length,);

    return null; // null will mean success
  }
}