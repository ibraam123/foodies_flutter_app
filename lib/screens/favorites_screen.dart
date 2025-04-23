import 'package:flutter/material.dart';
import 'package:foodies2_flutter_app/screens/plan_meals_screen.dart';
import 'package:foodies2_flutter_app/screens/search_screen.dart';
import 'package:provider/provider.dart';

import '../providers/favorite_meals_provider.dart';
import '../screens/details_meal_screen.dart';
import '../services/hive_service.dart';
import '../widgets/custom_widgets/custom_bottom_navigation_bar.dart';
import 'home_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  static String id = 'FavoritesScreen';

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    // Refresh favorites when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoritesProvider>(context, listen: false).loadFavorites();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (_selectedIndex == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      } else if (_selectedIndex == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PlanMealsScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        // This removes the back button
        title: const Text(
          'My Favorites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final favorites = favoritesProvider.favorites;

          if (favorites.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tap the heart icon on meals to add them here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8, // Adjusted for smaller containers
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final meal = favorites[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealDetailScreen(mealId: meal.id),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image with favorite button
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.network(
                                meal.imageUrl,
                                height: 100, // Reduced height
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 100,
                                    width: double.infinity,
                                    color: Colors.grey.shade100,
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey.shade400,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: GestureDetector(
                                onTap: () async {
                                  // First show the confirmation dialog
                                  final shouldRemove = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: const Text(
                                            'Remove from favorites?',
                                          ),
                                          content: const Text(
                                            'Are you sure you want to remove this meal from your favorites?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
                                              child: const Text('Remove'),
                                            ),
                                          ],
                                        ),
                                  );

                                  // If user confirmed, remove the favorite
                                  if (shouldRemove == true) {
                                    favoritesProvider.toggleFavorite(meal);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${meal.name} removed from favorites',
                                        ),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.redAccent,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Meal details
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const SizedBox(width: 4),
                                  Text(
                                    meal.category,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
