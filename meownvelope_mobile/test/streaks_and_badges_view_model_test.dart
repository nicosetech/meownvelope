import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:meownvelope_mobile/data_types/badge_data.dart';
import 'package:meownvelope_mobile/pages/home_pages/streaks_and_badges_view_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory testDirectory;
  late Box<BadgeData> badgesBox;
  late StreaksAndBadgesViewModel viewModel;

  setUp(() async {
    testDirectory = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(testDirectory.path);

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(BadgeDataAdapter());
    }

    badgesBox = await Hive.openBox<BadgeData>('test_badges_box');
    viewModel = StreaksAndBadgesViewModel(badgesBox: badgesBox);
  });

  tearDown(() async {
    viewModel.dispose();
    await badgesBox.clear();
    await badgesBox.close();
    await testDirectory.delete(recursive: true);
  });

  group('StreaksAndBadgesViewModel', () {
    test('isUnlocked returns false when badge data is missing', () {
      final result = viewModel.isUnlocked('missing_badge');
      expect(result, isFalse);
    });

    test('getDescription returns fallback when badge data is missing', () {
      final result = viewModel.getDescription('missing_badge');
      expect(result, 'No badge description available yet.');
    });

    test('getBadgeData returns stored badge data for existing badge', () async {
      const badgeKey = 'sample_badge';

      final badgeData = BadgeData(
        name: 'Sample Badge',
        description: 'Earned for testing',
        isUnlocked: true,
        dateEarned: DateTime(2026, 4, 16),
      );

      await badgesBox.put(badgeKey, badgeData);

      final result = viewModel.getBadgeData(badgeKey);

      expect(result, isNotNull);
      expect(result!.name, 'Sample Badge');
      expect(result.description, 'Earned for testing');
      expect(result.isUnlocked, isTrue);
      expect(result.dateEarned, DateTime(2026, 4, 16));
    });

    test('isUnlocked returns true when stored badge is unlocked', () async {
      const badgeKey = 'unlocked_badge';

      await badgesBox.put(
        badgeKey,
        BadgeData(
          name: 'Unlocked Badge',
          description: 'This badge is unlocked',
          isUnlocked: true,
        ),
      );

      final result = viewModel.isUnlocked(badgeKey);

      expect(result, isTrue);
    });

    test('isUnlocked returns false when stored badge is locked', () async {
      const badgeKey = 'locked_badge';

      await badgesBox.put(
        badgeKey,
        BadgeData(
          name: 'Locked Badge',
          description: 'Still locked',
          isUnlocked: false,
        ),
      );

      final result = viewModel.isUnlocked(badgeKey);

      expect(result, isFalse);
    });

    test('getDescription returns stored description when badge exists', () async {
      const badgeKey = 'described_badge';

      await badgesBox.put(
        badgeKey,
        BadgeData(
          name: 'Described Badge',
          description: 'Custom description',
          isUnlocked: false,
        ),
      );

      final result = viewModel.getDescription(badgeKey);

      expect(result, 'Custom description');
    });
  });
}