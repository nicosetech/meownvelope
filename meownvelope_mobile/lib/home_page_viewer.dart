import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/pages/home_pages/abstract_home_page.dart';
import 'package:meownvelope_mobile/pages/home_pages/envelope_list_page.dart';
import 'package:meownvelope_mobile/utils/widgets/meownvelope_app_bar.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/navigation_drawer.dart';
import 'package:meownvelope_mobile/pages/home_pages/profile/profile_page.dart';
import 'package:meownvelope_mobile/pages/home_pages/streaks_and_badges.dart';

class HomePageViewer extends StatefulWidget {
  const HomePageViewer({super.key});

  @override
  State<HomePageViewer> createState() => _HomePageViewerState();
}

class _HomePageViewerState extends State<HomePageViewer> {

  final List<AbstractHomePage> pages = [EnevelopeListPage(),ProfilePage(), StreaksAndBadgesPage()];

  Widget currentPage = EnevelopeListPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MeownvelopeColors.bgColor,
      // bar to display title and paw icon
      appBar: MeownvelopeAppBar(titleText: "Meownvelope"),

      //page layout
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(width: 30, height: 80), // for space between sections
              // menu button
              //top section to include menu button, cash visual, and buttons
              Expanded(child: currentPage),
            ],
          ),
          MeowNavigationDrawer(pages: pages, changePage: changePage),
        ],
      ),
    );
  }

  void changePage(Widget newPage) {
    setState(() {
      currentPage = newPage;
    });
  }
}

class NavigationButton extends StatelessWidget {
  final VoidCallback toggleDrawer;

  const NavigationButton({
    super.key,
    required this.toggleDrawer,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Ink(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: MeownvelopeColors.lightBlue,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: IconButton(
          icon: Icon(
            Icons.keyboard_double_arrow_right,
            color: MeownvelopeColors.darkBlue,
            size: 60,
          ),
          onPressed: () {
            toggleDrawer();
          },
        ),
      ),
    );
  }
}
