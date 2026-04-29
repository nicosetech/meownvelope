import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meownvelope_mobile/data/badges/badge_definitions.dart';
import 'package:meownvelope_mobile/data/badges/badge_model.dart';
import 'package:meownvelope_mobile/data_types/badge_data.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';

class StreaksAndBadgesViewModel extends ChangeNotifier {
  late final Box<BadgeData> _badgesBox;
  late final ValueListenable<Box<BadgeData>> _badgesListenable;
  late final VoidCallback _badgesListener;

  StreaksAndBadgesViewModel({Box<BadgeData>? badgesBox}) {
    _badgesBox = badgesBox ?? HiveDatabase.getBadges();
    _badgesListenable = _badgesBox.listenable();
    _badgesListener = () => notifyListeners();
    _badgesListenable.addListener(_badgesListener);
  }

  List<BadgeModel> get badges => BadgeDefinitions.all;

  BadgeData? getBadgeData(String badgeKey) {
    return _badgesBox.get(badgeKey);
  }

  bool isUnlocked(String badgeKey) {
    return getBadgeData(badgeKey)?.isUnlocked ?? false;
  }

  String getDescription(String badgeKey) {
    return getBadgeData(badgeKey)?.description ??
        'No badge description available yet.';
  }

  @override
  void dispose() {
    _badgesListenable.removeListener(_badgesListener);
    super.dispose();
  }
}