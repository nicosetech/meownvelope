import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/data/badges/badge_model.dart';
import 'package:meownvelope_mobile/pages/home_pages/abstract_home_page.dart';
import 'package:meownvelope_mobile/pages/home_pages/streaks_and_badges_view_model.dart';
import 'package:meownvelope_mobile/utils/styling/custom_icons.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';

class StreaksAndBadgesView extends AbstractHomePage {
  const StreaksAndBadgesView({super.key});

  @override
  State<StreaksAndBadgesView> createState() => _StreaksAndBadgesViewState();

  @override
  IconData getIcon() {
    return Icons.emoji_events;
  }
}

class _StreaksAndBadgesViewState extends State<StreaksAndBadgesView> {
  late final StreaksAndBadgesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = StreaksAndBadgesViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _showBadgeDetails({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool unlocked,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: MeownvelopeColors.lightBlue,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: MeownvelopeColors.darkBlue,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: MeownvelopeColors.darkBlue.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: MeownvelopeColors.darkBlue,
                    ),
                  ),
                ),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: unlocked ? color : color.withOpacity(0.5),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: MeownvelopeColors.darkBlue,
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        icon,
                        size: 48,
                        color: MeownvelopeColors.darkBlue,
                      ),
                      if (!unlocked)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              CustomIcons.lock,
                              size: 14,
                              color: MeownvelopeColors.darkBlue,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: martian(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MeownvelopeColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: martian(
                    fontSize: 12,
                    color: MeownvelopeColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  unlocked ? 'Unlocked' : 'Locked',
                  style: martian(
                    fontSize: 11,
                    color: MeownvelopeColors.iconColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        final List<BadgeModel> badges = _viewModel.badges;

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
                Container(
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
                      final bool unlocked =
                          _viewModel.isUnlocked(badge.badgeKey);
                      final String description =
                          _viewModel.getDescription(badge.badgeKey);

                      return GestureDetector(
                        onTap: () {
                          _showBadgeDetails(
                            title: badge.title,
                            description: description,
                            icon: badge.icon,
                            color: badge.color,
                            unlocked: unlocked,
                          );
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: unlocked
                                    ? badge.color
                                    : badge.color.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    badge.icon,
                                    size: 22,
                                    color: unlocked
                                        ? MeownvelopeColors.darkBlue
                                        : MeownvelopeColors.iconColor,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    badge.title,
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
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}