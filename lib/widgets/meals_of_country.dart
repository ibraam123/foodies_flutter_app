import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/meal_provider.dart';
import 'meal_card_from_network.dart';

class MealsOfCountry extends StatelessWidget {
  const MealsOfCountry({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MealProvider>(
      builder: (context, mealProvider, child) {
        // Automatically load meals for a default country if none selected
        if (mealProvider.countryMeals.isEmpty &&
            mealProvider.selectedCountry == null &&
            !mealProvider.isLoadingCountryMeals) {
          // Use addPostFrameCallback to avoid setState in build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            mealProvider.loadMealsByCountry('American');
          });

          return const Center(child: CircularProgressIndicator());
        }

        // Show loading spinner if data is being fetched
        if (mealProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show message if no meals found
        if (mealProvider.countryMeals.isEmpty) {
          return const Center(
            child: Text(
              'No meals found for this country',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        // Display list of meals
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: mealProvider.countryMeals.length,
          itemBuilder: (context, index) {
            final meal = mealProvider.countryMeals[index];
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
