import 'package:demo_app/provider/layout_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../layout/Watch_Detail.dart';

class NavBarItem {
  String icon;
  String label;

  NavBarItem({this.icon = 'assets/icons/Watch.svg', this.label = 'Label'});
}

class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<NavBarItem> items = [
    NavBarItem(icon: ('assets/icons/dashboard.svg'), label: 'Dashboard'),
    NavBarItem(icon: 'assets/icons/watch.svg', label: 'Watch'),
    NavBarItem(
        icon: ('assets/icons/media_library.svg'), label: 'Media Library'),
    NavBarItem(icon: ('assets/icons/more.svg'), label: 'More')
  ];
  int currIndex = 1;
  @override
  Widget build(BuildContext context) {
    Radius radius = const Radius.circular(20);

    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
      child: BottomNavigationBar(
        currentIndex: currIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2E2739),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xff827D88),
        selectedFontSize: 10,
        unselectedFontSize: 10,
        elevation: 12,
        onTap: (value) {
          setState(() {
            currIndex = value;
          });
          // Provider.of<LayoutProvider>(context, listen: false).setLayout(value);
        },
        items: items
            .map(
              (e) => BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    e.icon,
                    color: Color(0xff827D88),
                  ),
                  label: e.label,
                  activeIcon: SvgPicture.asset(
                    e.icon,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  )),
            )
            .toList(),
      ),
    );
  }
}
