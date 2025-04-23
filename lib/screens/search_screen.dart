import 'package:flutter/material.dart';
import 'package:foodies2_flutter_app/screens/plan_meals_screen.dart';
import 'package:provider/provider.dart';
import '../models/meal_model.dart';
import '../providers/meal_provider.dart';
import '../widgets/category_selction_dialog.dart';
import '../widgets/countries_selction_dialog.dart';
import '../widgets/custom_widgets/custom_bottom_navigation_bar.dart';
import 'details_meal_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static String id = 'SearchScreen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _selectedIndex = 1;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    mealProvider.loadCategories();
    mealProvider.loadCountries();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (_selectedIndex == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FavoritesScreen()),
        );
      } else if (_selectedIndex == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PlanMealsScreen()),
        );
      }
    });
  }

  void _onCategoryTap(String categoryName) {
    final mealProvider = Provider.of<MealProvider>(context, listen: false);

    if (_searchQuery.isEmpty) {
      mealProvider.loadMealsByCategory(categoryName);
    } else {
      mealProvider.searchMealsByCategory(_searchQuery, categoryName);
    }

    Navigator.pop(context);
  }

  void _onCountryTap(String countryName) {
    final mealProvider = Provider.of<MealProvider>(context, listen: false);

    if (_searchQuery.isEmpty) {
      mealProvider.loadMealsByCountry(countryName);
    } else {
      mealProvider.searchMealsByCountry(_searchQuery, countryName);
    }

    Navigator.pop(context);
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    final mealProvider = Provider.of<MealProvider>(context, listen: false);

    if (mealProvider.selectedCategory != null) {
      mealProvider.searchMealsByCategory(query, mealProvider.selectedCategory!);
    } else if (mealProvider.selectedCountry != null) {
      mealProvider.searchMealsByCountry(query, mealProvider.selectedCountry!);
    } else {
      mealProvider.searchMeals(query);
    }
  }

  void _showCategoryDialog(BuildContext context, MealProvider mealProvider) {
    showDialog(
      context: context,
      builder: (context) => CategorySelectionDialog(
        mealProvider: mealProvider,
        onCategoryTap: _onCategoryTap,
      ),
    );
  }

  void _showCountryDialog(BuildContext context, MealProvider mealProvider) {
    showDialog(
      context: context,
      builder: (context) => CountrySelectionDialog(
        mealProvider: mealProvider,
        onCountryTap: _onCountryTap,
      ),
    );
  }

  void _clearFilters() {
    Provider.of<MealProvider>(context, listen: false).clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Replace with your custom search bar that calls _onSearchChanged
            CustomSearchBarForMainScreen(
              onSearchChanged: _onSearchChanged,
            ),
            const SizedBox(height: 16),
            _buildFilterChipsRow(context, mealProvider),
            const SizedBox(height: 16),
            _buildActiveFiltersChips(mealProvider),
            const SizedBox(height: 16),
            _buildMealsList(mealProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChipsRow(BuildContext context, MealProvider mealProvider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            label: 'Categories',
            onTap: () => _showCategoryDialog(context, mealProvider),
          ),
          const SizedBox(width: 10),
          const FilterChip(label: 'Ingredients'), // Not implemented yet
          const SizedBox(width: 10),
          FilterChip(
            label: 'Countries',
            onTap: () => _showCountryDialog(context, mealProvider),
          ),
          const SizedBox(width: 10),
          if (mealProvider.selectedCategory != null || mealProvider.selectedCountry != null)
            FilterChip(
              label: 'Clear Filters',
              onTap: _clearFilters,
            ),
        ],
      ),
    );
  }

  // New method to show active filters
  Widget _buildActiveFiltersChips(MealProvider mealProvider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (mealProvider.selectedCategory != null)
            Chip(
              label: Text(
                'Category: ${mealProvider.selectedCategory!}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              backgroundColor: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onDeleted: () => mealProvider.clearCategoryFilter(),
              deleteIconColor: Colors.white,
            ),
          const SizedBox(width: 10),
          if (mealProvider.selectedCountry != null)
            Chip(
              label: Text(
                'Country: ${mealProvider.selectedCountry!}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              backgroundColor: Colors.orangeAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onDeleted: () => mealProvider.clearCountryFilter(),
              deleteIconColor: Colors.white,
            ),
        ],
      ),
    );
  }

  Widget _buildMealsList(MealProvider mealProvider) {
    if (mealProvider.isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    // Use filteredMeals instead of separate lists
    List<Meal> mealsToDisplay = mealProvider.filteredMeals;

    if (mealsToDisplay.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("No meals found"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _clearFilters,
                child: const Text("Clear Filters"),
              )
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: mealsToDisplay.length,
        itemBuilder: (context, index) {
          final meal = mealsToDisplay[index];
          return _buildMealListItem(meal);
        },
      ),
    );
  }

  Widget _buildMealListItem(Meal meal) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MealDetailScreen(mealId: meal.id),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              meal.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            meal.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Category: ${meal.category}'),
              if (meal.originCountry != null && meal.originCountry!.isNotEmpty)
                Text('Country: ${meal.originCountry}'),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}

class FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const FilterChip({
    super.key,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.greenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

// You'll also need to update the CustomSearchBarForMainScreen to accept an onSearchChanged callback
class CustomSearchBarForMainScreen extends StatelessWidget {
  final Function(String)? onSearchChanged;

  const CustomSearchBarForMainScreen({
    super.key,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: TextField(
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search for meals...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }
}