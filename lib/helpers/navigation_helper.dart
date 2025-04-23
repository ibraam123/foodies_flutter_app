// navigation_helper.dart
import 'package:flutter/material.dart';

import '../screens/favorites_screen.dart';
import '../screens/home_screen.dart';
import '../screens/plan_meals_screen.dart';
import '../screens/search_screen.dart';

class NavigationHelper {
  static List<NavigationItem> items = [
     NavigationItem(
      index: 0,
      label: 'Home',
      icon: Icons.home,
      routeName: HomeScreen.id,
    ),
     NavigationItem(
      index: 1,
      label: 'Search',
      icon: Icons.search,
      routeName: SearchScreen.id,
    ),
     NavigationItem(
      index: 2,
      label: 'Favorites',
      icon: Icons.favorite,
      routeName: FavoritesScreen.id,
    ),
    NavigationItem(
      index: 3,
      label: 'Plan Meals',
      icon: Icons.calendar_today,
      routeName: PlanMealsScreen.id,
    ),
  ];

  static void navigateTo(BuildContext context, int index) {
    final routeName = items[index].routeName;
    Navigator.pushReplacementNamed(context, routeName);
  }
}

class NavigationItem {
  final int index;
  final String label;
  final IconData icon;
  final String routeName;

  const NavigationItem({
    required this.index,
    required this.label,
    required this.icon,
    required this.routeName,
  });
}