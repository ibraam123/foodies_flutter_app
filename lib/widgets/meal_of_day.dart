import 'package:flutter/material.dart';

import '../models/meal_model.dart';
import 'add_to_plan_button.dart';

class MealOfTheDay extends StatelessWidget {
  final Size size;
  final Meal meal;

  const MealOfTheDay({super.key, required this.size, required this.meal});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Meal Of The Day',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: size.height * 0.18,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(meal.imageUrl, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Text(
                    meal.name,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Positioned(right: 5, bottom: 5, child: AddToPlanButton(
                  title: meal.name,
                  mealId: meal.id,
                  imageUrl: meal.imageUrl,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
