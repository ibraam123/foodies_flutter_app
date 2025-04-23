import 'package:flutter/material.dart';
import 'package:foodies2_flutter_app/screens/plan_meals_screen.dart';
import 'package:foodies2_flutter_app/screens/search_screen.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import '../widgets/category_list.dart';
import '../widgets/country_list.dart';
import '../widgets/custom_widgets/custom_bottom_navigation_bar.dart';
import '../widgets/greeting_header.dart';
import '../widgets/meal_card_from_network.dart';
import '../widgets/meal_of_day.dart';
import '../widgets/meals_of_country.dart';
import 'favorites_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String id = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mealProvider = Provider.of<MealProvider>(context, listen: false);
      mealProvider.loadRandomMeal();
      mealProvider.loadCategories();
      mealProvider.loadCountries();
      // Load initial category meals (you might want to load a default category)
      if (mealProvider.categories.isNotEmpty) {
        mealProvider.loadMealsByCategory(mealProvider.categories.first.name);
      }
    });
  }

  void _onCategoryTap(String categoryName) {
    Provider.of<MealProvider>(
      context,
      listen: false,
    ).loadMealsByCategory(categoryName);
  }

  void _onCountryTap(String countryName) {
    Provider.of<MealProvider>(
      context,
      listen: false,
    ).loadMealsByCountry(countryName);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SearchScreen();
            },
          ),
        );
      } else if (_selectedIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return FavoritesScreen();
            },
          ),
        );
      } else if (_selectedIndex == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PlanMealsScreen();
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print('Home screen $_selectedIndex');

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Consumer<MealProvider>(
        builder: (context, mealProvider, child) {
          return Padding(
            padding: const EdgeInsets.only(left: 16),
            child: _buildContent(mealProvider, size),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildContent(MealProvider mealProvider, Size size) {
    if (mealProvider.error != null) {
      return Center(child: Text("Error: ${mealProvider.error}"));
    }

    return ListView(
      children: [
        const GreetingHeader(),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
        _buildMealOfTheDay(mealProvider, size),
        const SizedBox(height: 15),
        const CategoryHeader(),
        SizedBox(height: 5),
        _buildCategoryList(mealProvider),
        SizedBox(height: 230, child: MealsOfCategory()),
        const SizedBox(height: 10),
        const CountryHeader(),
        SizedBox(height: 5),
        _buildCountryList(mealProvider),
        SizedBox(height: 230, child: MealsOfCountry()),
      ],
    );
  }

  Widget _buildMealOfTheDay(MealProvider mealProvider, Size size) {
    if (mealProvider.isLoading && mealProvider.randomMeal == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (mealProvider.randomMeal == null) {
      return const Center(child: Text("No meal found"));
    }
    return MealOfTheDay(meal: mealProvider.randomMeal!, size: size);
  }

  Widget _buildCategoryList(MealProvider mealProvider) {
    if (mealProvider.isLoading && mealProvider.categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (mealProvider.categories.isEmpty) {
      return const Center(child: Text("No categories found"));
    }
    return CategoryList(
      categories: mealProvider.categories,
      onCategoryTap: _onCategoryTap,
    );
  }

  Widget _buildCountryList(MealProvider mealProvider) {
    if (mealProvider.isLoading && mealProvider.countries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (mealProvider.countries.isEmpty) {
      return const Center(child: Text("No countries found"));
    }
    return CountryList(
      countries: mealProvider.countries,
      onCountryTap: _onCountryTap,
    );
  }
}


class MealsOfCategory extends StatelessWidget {
  const MealsOfCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MealProvider>(
      builder: (context, mealProvider, child) {
        // If no meals loaded and no category selected, load default
        if (mealProvider.categoryMeals.isEmpty &&
            mealProvider.selectedCategory == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            mealProvider.loadMealsByCategory('Beef'); // Default category
          });
          return const Center(child: CircularProgressIndicator());
        }

        if (mealProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (mealProvider.categoryMeals.isEmpty) {
          return const Center(
            child: Text(
              'No meals found for this category',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: mealProvider.categoryMeals.length,
          itemBuilder: (context, index) {
            final meal = mealProvider.categoryMeals[index];
            return MealCardFromNetwork(
              imagePath: meal.imageUrl,
              title: meal.name,
              mealId: meal.id,
              category: meal.category,
            );
          },
        );
      },
    );
  }
}


class CategoryHeader extends StatelessWidget {
  const CategoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Categories',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }
}

class CountryHeader extends StatelessWidget {
  const CountryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Countries',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }
}


