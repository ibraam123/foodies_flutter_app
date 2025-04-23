


import 'package:flutter/cupertino.dart';

import '../models/favorite_meal_model.dart';
import '../services/hive_service.dart';

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
