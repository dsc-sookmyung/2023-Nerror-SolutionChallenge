import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:marbon/color.dart';

import '../mainscreen/main_screen.dart';
import '../mypage/my_page.dart';
import '../smartscan/smartscan.dart';

class BottomTabBar extends StatefulWidget {
  const BottomTabBar({super.key});

  @override
  State<BottomTabBar> createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  int _selectedIndex = 1;

  List<Widget> tabItems = [
    const SmartScan(),
    const MainScreen(),
    MyPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: tabItems[_selectedIndex],
      ),
      bottomNavigationBar: FlashyTabBar(
        height: 55,
        animationCurve: Curves.linear,
        selectedIndex: _selectedIndex,
        iconSize: 30,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.search),
            title: const Text(
              'Smartscan',
              style: TextStyle(fontSize: 12),
            ),
            activeColor: green_color,
            inactiveColor: unselected_color,
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.home_filled),
            title: const Text(
              'Home',
              style: TextStyle(fontSize: 12),
            ),
            activeColor: green_color,
            inactiveColor: unselected_color,
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.person_pin_rounded),
            title: const Text(
              'My page',
              style: TextStyle(fontSize: 12),
            ),
            activeColor: green_color,
            inactiveColor: unselected_color,
          ),
        ],
      ),
    );
  }
}
