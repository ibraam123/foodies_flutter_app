// providers/planned_meals_provider.dart
import 'package:flutter/material.dart';
import '../models/plan_meal_model.dart';
import '../services/hive_service.dart';

class PlannedMealsProvider with ChangeNotifier {
  Map<String, List<PlannedMeal>> _plannedMealsByDay = {};

  Map<String, List<PlannedMeal>> get plannedMealsByDay => _plannedMealsByDay;

  PlannedMealsProvider() {
    loadPlannedMeals();
  }

  Future<void> loadPlannedMeals() async {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    for (final day in days) {
      _plannedMealsByDay[day] = HiveService.getPlannedMealsForDay(day);
    }

    notifyListeners();
  }


  Future<void> addMealToPlan(PlannedMeal meal) async {
    await HiveService.addToPlanned(meal);
    _plannedMealsByDay[meal.day]?.add(meal);
    notifyListeners();
  }

  Future<void> removeMealFromPlan(String mealId, String day) async {
    await HiveService.removePlannedMeal(mealId, day);
    _plannedMealsByDay[day]?.removeWhere((meal) => meal.mealId == mealId);
    notifyListeners();
  }
  bool isMealAlreadyExistOnThisDay(String mealId, String day) {
    return HiveService.isMealAlreadyExistOnThisDay(mealId, day);
  }


}