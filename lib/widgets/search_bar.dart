import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/meal_provider.dart';

class CustomeSearchBar extends StatelessWidget {
  const CustomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: kPrimaryColor,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Search your meal',
        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: kPrimaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}


class CustomSearchBarForMainScreen extends StatefulWidget {
  const CustomSearchBarForMainScreen({super.key});

  @override
  State<CustomSearchBarForMainScreen> createState() => _CustomSearchBarForMainScreenState();
}

class _CustomSearchBarForMainScreenState extends State<CustomSearchBarForMainScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      final query = _searchController.text.trim();
      final mealProvider = Provider.of<MealProvider>(context, listen: false);
      final currentCategory = mealProvider.selectedCategory;
      final currentCountry = mealProvider.selectedCountry;

      if (query.isEmpty && currentCategory == null && currentCountry == null) {
        mealProvider.loadInitialData();
      } else if (query.isNotEmpty && currentCategory != null) {
        mealProvider.searchMealsByCategory(query, currentCategory);
      } else if (query.isNotEmpty && currentCountry != null) {
        mealProvider.searchMealsByCountry(query, currentCountry);
      } else if (query.isEmpty && currentCategory != null) {
        mealProvider.loadMealsByCategory(currentCategory);
      } else if (query.isEmpty && currentCountry != null) {
        mealProvider.loadMealsByCountry(currentCountry);
      } else {
        mealProvider.searchMeals(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    final currentCategory = mealProvider.selectedCategory;
    final currentCountry = mealProvider.selectedCountry;

    return TextField(
      controller: _searchController,
      cursorColor: kPrimaryColor,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: currentCategory != null
            ? 'Search in $currentCategory'
            : currentCountry != null
            ? 'Search in $currentCountry'
            : 'Search your meal',
        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: kPrimaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
