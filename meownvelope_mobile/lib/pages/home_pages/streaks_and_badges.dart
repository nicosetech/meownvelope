import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meownvelope_mobile/data_types/badge_data.dart';
import 'package:meownvelope_mobile/utils/styling/custom_icons.dart';
import 'package:meownvelope_mobile/pages/home_pages/abstract_home_page.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';

class StreaksAndBadgesPage extends AbstractHomePage {
  const StreaksAndBadgesPage({super.key});

  @override
  State<StreaksAndBadgesPage> createState() => _StreaksAndBadgesPageState();

  @override
  IconData getIcon() {
    return Icons.emoji_events;
  }
}

class _StreaksAndBadgesPageState extends State<StreaksAndBadgesPage> {
  final List<Color> presetColors = [
    const Color(0xFFFFCCCC),
    const Color(0xFFFFEDCC),
    const Color(0xFFCCF5D5),
    const Color(0xFFE8CCFF),
    const Color(0xFFCCE5FF),
    const Color(0xFFE8E8E8),
    const Color(0xFFFFE5F2),
    const Color(0xFFCCFFED),
  ];

  late final List<Map<String, dynamic>> badges = [
    {
      'badgeKey': 'Purrfect Start',
      'title': 'Purrfect Start',
      'icon': Icons.pets,
      'color': presetColors[0],
    },
    {
      'badgeKey': 'Kitten Cache',
      'title': 'Kitten Cache',
      'icon': Icons.mail_outline,
      'color': presetColors[1],
    },
    {
      'badgeKey': 'Claw-ver Saver',
      'title': 'Clawver Saver',
      'icon': Icons.email,
      'color': presetColors[2],
    },
    {
      'badgeKey': 'Nine Lives',
      'title': 'Nine Lives',
      'icon': Icons.favorite_border,
      'color': presetColors[3],
    },
    {
      'badgeKey': 'Pawsitive Progress',
      'title': 'Pawsitive Progress',
      'icon': Icons.attach_money,
      'color': presetColors[4],
    },
    {
      'badgeKey': 'Whisker Wealth',
      'title': 'Whisker Wealth',
      'icon': Icons.savings_outlined,
      'color': presetColors[5],
    },
    {
      'badgeKey': 'Meow-mentum',
      'title': 'Meow-mentum',
      'icon': Icons.mark_email_unread_outlined,
      'color': presetColors[6],
    },
    {
      'badgeKey': 'Kitten Saver',
      'title': 'Kitten Saver',
      'icon': Icons.local_fire_department_outlined,
      'color': presetColors[7],
    },
    {
      'badgeKey': 'Purrfessional Saver',
      'title': 'Purrfessional Saver',
      'icon': Icons.whatshot_outlined,
      'color': presetColors[0],
    },
    {
      'badgeKey': 'Purrseverence',
      'title': 'Purrseverance',
      'icon': Icons.verified_outlined,
      'color': presetColors[1],
    },
    {
      'badgeKey': 'Purrtnership',
      'title': 'Purrtnership',
      'icon': Icons.people_outline,
      'color': presetColors[2],
    },
    {
      'badgeKey': 'Claws for Celebration',
      'title': 'Claws for Celebration',
      'icon': Icons.auto_awesome_outlined,
      'color': presetColors[3],
    },
    {
      'badgeKey': 'Curiosity Streak',
      'title': 'Curiosity Streak',
      'icon': Icons.remove_red_eye_outlined,
      'color': presetColors[4],
    },
    {
      'badgeKey': 'Pawsitive Habits',
      'title': 'Pawsitive Habits',
      'icon': Icons.visibility_outlined,
      'color': presetColors[5],
    },
    {
      'badgeKey': 'Purrsistence',
      'title': 'Purrsistence',
      'icon': Icons.compare_arrows_outlined,
      'color': presetColors[6],
    },
    {
      'badgeKey': 'Pawductivity',
      'title': 'Pawductivity',
      'icon': Icons.swap_horiz_outlined,
      'color': presetColors[7],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final badgesBox = HiveDatabase.getBadges();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                'Meowchievements',
                style: martian(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'My Badges',
                style: martian(
                  fontSize: 20,
                  color: MeownvelopeColors.iconColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder(
              valueListenable: badgesBox.listenable(),
              builder: (context, Box<BadgeData> box, _) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: MeownvelopeColors.medBlue,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: MeownvelopeColors.darkBlue.withOpacity(0.10),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: badges.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final badge = badges[index];
                      final String badgeKey = badge['badgeKey'] as String;
                      final String title = badge['title'] as String;
                      final Color tileColor = badge['color'] as Color;
                      final BadgeData? badgeData = box.get(badgeKey);
                      final bool unlocked = badgeData?.isUnlocked ?? false;

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: unlocked
                                  ? tileColor
                                  : tileColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  badge['icon'] as IconData,
                                  size: 22,
                                  color: unlocked
                                      ? MeownvelopeColors.darkBlue
                                      : MeownvelopeColors.iconColor,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: martian(fontSize: 8.5),
                                ),
                              ],
                            ),
                          ),
                          if (!unlocked)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  CustomIcons.lock,
                                  size: 12,
                                  color: MeownvelopeColors.darkBlue,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Savings Streak',
                style: martian(fontSize: 20),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: MeownvelopeColors.medBlue,
                border: Border.all(
                  color: MeownvelopeColors.iconColor,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: MeownvelopeColors.darkBlue.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Container(
                height: 34,
                decoration: BoxDecoration(
                  color: MeownvelopeColors.lightBlue,
                  border: Border.all(
                    color: MeownvelopeColors.iconColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}