import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../helpers/navigation_helper.dart';

class NavigationItem {
  final String label;
  final IconData icon;

  NavigationItem({required this.label, required this.icon});
}


class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: NavigationHelper.items.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon ,),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}
