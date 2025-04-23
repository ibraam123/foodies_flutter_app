
import 'package:flutter/material.dart';

import '../helpers/navigation_helper.dart';
import '../widgets/custom_widgets/custom_bottom_navigation_bar.dart';

// base_screen.dart
class BaseScreen extends StatefulWidget {
  final int initialIndex;
  final Widget child;

  const BaseScreen({
    super.key,
    required this.initialIndex,
    required this.child,
  });

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    NavigationHelper.navigateTo(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}