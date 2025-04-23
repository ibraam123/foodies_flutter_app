import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/favorite_meal_model.dart';
import '../models/plan_meal_model.dart';

class HiveService {
  static const String _favoritesBoxName = 'favorites';
  static const String _plannedMealsBoxName = 'planned_meals';



  static late Box<FavoriteMeal> _favoritesBox;
  static late Box<PlannedMeal> _plannedMealsBox;



  // Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(FavoriteMealAdapter());
    Hive.registerAdapter(PlannedMealAdapter());

    _favoritesBox = await Hive.openBox<FavoriteMeal>(_favoritesBoxName);
    _plannedMealsBox = await Hive.openBox<PlannedMeal>(_plannedMealsBoxName);
  }


  static Future<void> addToPlanned(PlannedMeal meal) async {
    await _plannedMealsBox.add(meal);
  }

  static bool isMealAlreadyExistOnThisDay(String mealId, String day) {
    return _plannedMealsBox.values.any((meal) => meal.mealId == mealId && meal.day == day);
  }


  static List<PlannedMeal> getPlannedMealsForDay(String day) {
    return _plannedMealsBox.values
        .where((meal) => meal.day == day)
        .toList();
  }

  static Future<void> removePlannedMeal(String mealId, String day) async {
    final key = _plannedMealsBox.values
        .firstWhere((meal) => meal.mealId == mealId && meal.day == day)
        .key;
    await _plannedMealsBox.delete(key);
  }


  // Check if a meal is favorite
  static bool isFavorite(String mealId) {
    return _favoritesBox.containsKey(mealId);
  }

  // Add a meal to favorites
  static Future<void> addToFavorites(FavoriteMeal meal) async {
    await _favoritesBox.put(meal.id, meal);
  }

  // Remove a meal from favorites
  static Future<void> removeFromFavorites(String mealId) async {
    await _favoritesBox.delete(mealId);
  }

  // Toggle favorite status
  static Future<bool> toggleFavorite(FavoriteMeal meal) async {
    final isFav = isFavorite(meal.id);
    if (isFav) {
      await removeFromFavorites(meal.id);
      return false;
    } else {
      await addToFavorites(meal);
      return true;
    }
  }

  // Get all favorites
  static List<FavoriteMeal> getAllFavorites() {
    return _favoritesBox.values.toList();
  }
}


/*
// Provider to manage favorites state
class FavoritesProvider with ChangeNotifier {
  List<FavoriteMeal> _favorites = [];

  List<FavoriteMeal> get favorites => _favorites;

  FavoritesProvider() {
    _favorites = HiveService.getAllFavorites();
  }

  bool isFavorite(String mealId) {
    return HiveService.isFavorite(mealId);
  }

  Future<void> toggleFavorite(FavoriteMeal meal) async {
    final isNowFavorite = await HiveService.toggleFavorite(meal);

    // Update the list
    if (isNowFavorite) {
      _favorites.add(meal);
    } else {
      _favorites.removeWhere((item) => item.id == meal.id);
    }

    notifyListeners();
  }

  void loadFavorites() {
    _favorites = HiveService.getAllFavorites();
    notifyListeners();
  }
}

*/
