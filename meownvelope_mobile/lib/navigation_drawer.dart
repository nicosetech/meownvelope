import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/pages/home_pages/abstract_home_page.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';

class MeowNavigationDrawer extends StatefulWidget {
  const MeowNavigationDrawer({
    super.key,
    required this.pages,
    required this.changePage,
  });

  final List<AbstractHomePage> pages;
  final Function(Widget) changePage;

  @override
  State<MeowNavigationDrawer> createState() => _MeowNavigationDrawerState();
}

class _MeowNavigationDrawerState extends State<MeowNavigationDrawer> {
  bool open = false;

  final drawerWidth = 80.0;

  final drawerHeight = 0.5;

  final iconSize = 60.0;

  final animationSpeed = const Duration(milliseconds: 200);

  List<RadioModel> sampleData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < widget.pages.length; i++) {
      sampleData.add(RadioModel(widget.pages[i], i==0, widget.pages[i].getIcon()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: drawerWidth,
      height: MediaQuery.of(context).size.height * drawerHeight,

      child: TapRegion(
        onTapOutside: (event) {
          if (open) {
            setState(() {
              open = !open;
            });
          }
        },
        child: Stack(
          children: [generateNavbar(context), generateToggleButton()],
        ),
      ),
    );
  }

  AnimatedPositioned generateNavbar(BuildContext context) {
    return AnimatedPositioned(
      duration: animationSpeed,
      left: open ? 0 : -drawerWidth,
      top: drawerWidth-8,
      child: Container(
        width: drawerWidth,
        height: (MediaQuery.of(context).size.height * drawerHeight)-drawerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(8),
          ),
          color: MeownvelopeColors.lightBlue,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 8.0, right: 8.0),
          child: ListView.builder(
            itemCount: widget.pages.length,
            itemBuilder: (BuildContext context, int index) {
              return IconButton(
                style: IconButton.styleFrom(
                  fixedSize: Size(drawerWidth, drawerWidth-16),
                  backgroundColor: sampleData[index].isSelected ? MeownvelopeColors.medBlue : MeownvelopeColors.lightBlue,
                ),
                icon: Icon(sampleData[index].icon, size: iconSize/1.5),
                color: MeownvelopeColors.darkBlue,
                onPressed: () {
                  widget.changePage(sampleData[index].page);
                  for (var element in sampleData) {
                    element.isSelected = false;
                  }
                  sampleData[index].isSelected = true;
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Ink generateToggleButton() {
    return Ink(
      height: drawerWidth,
      width: drawerWidth,
      decoration: BoxDecoration(
        color: MeownvelopeColors.lightBlue,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: AnimatedRotation(
        turns: open ? 0 : -.5,
        duration: animationSpeed,
        child: IconButton(
          icon: Icon(
            Icons.keyboard_double_arrow_left,
            color: MeownvelopeColors.darkBlue,
            size: iconSize,
          ),
          onPressed: () {
            setState(() {
              open = !open;
            });
          },
        ),
      ),
    );
  } 
}

class RadioModel {
  AbstractHomePage page;
  bool isSelected;
  final IconData icon;

  RadioModel(this.page, this.isSelected, this.icon);
}