import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/area_model.dart';
import '../models/category_model.dart';
import '../models/meal_model.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';
  static const Duration timeoutDuration = Duration(seconds: 15);


  Future<Meal?> fetchRandomMeal() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/random.php'),
      ).timeout(timeoutDuration);

      return _handleMealResponse(response);
    } catch (e) {
      throw _handleError('random meal', e);
    }
  }

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories.php'),
      ).timeout(timeoutDuration);

      return _handleListResponse<Category>(
        response,
        'categories',
            (json) => Category.fromJson(json),
      );
    } catch (e) {
      throw _handleError('categories', e);
    }
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/filter.php?c=${Uri.encodeComponent(category)}'),
      ).timeout(timeoutDuration);

      return _handleFilteredMealsResponse(response, category: category);
    } catch (e) {
      throw _handleError('meals by category', e);
    }
  }

  Future<List<Country>> fetchCountries() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/list.php?a=list'),
      ).timeout(timeoutDuration);

      return _handleListResponse<Country>(
        response,
        'meals',
            (json) => Country.fromJson(json),
      );
    } catch (e) {
      throw _handleError('countries', e);
    }
  }

  Future<List<Meal>> fetchMealsByCountry(String country) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/filter.php?a=${Uri.encodeComponent(country)}'),
      ).timeout(timeoutDuration);

      return _handleFilteredMealsResponse(response, country: country);
    } catch (e) {
      throw _handleError('meals by country', e);
    }
  }

  Future<Meal> fetchMealById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/lookup.php?i=$id'),
      ).timeout(timeoutDuration);

      final meal = _handleMealResponse(response);
      if (meal == null) throw Exception('Meal not found');
      return meal;
    } catch (e) {
      throw _handleError('meal by ID', e);
    }
  }

  // New search methods
  Future<List<Meal>> searchMealsByName(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search.php?s=${Uri.encodeComponent(query)}'),
      ).timeout(timeoutDuration);

      return _handleFullMealsResponse(response);
    } catch (e) {
      throw _handleError('meals by name', e);
    }
  }

  Future<List<Meal>> searchMealsByNameAndCategory(String query, String category) async {
    try {
      // First get all meals in category
      final categoryMeals = await fetchMealsByCategory(category);

      // If no search query, return all category meals
      if (query.isEmpty) return categoryMeals;

      // Then search within these meals
      final searchResults = await searchMealsByName(query);

      // Filter to only include meals that are in both lists
      final categoryMealIds = categoryMeals.map((m) => m.id).toSet();
      return searchResults.where((m) => categoryMealIds.contains(m.id)).toList();
    } catch (e) {
      throw _handleError('meals by name and category', e);
    }
  }
  Future<List<Meal>> searchMealsByNameAndCountry(String query, String country) async {
    try {
      // First get all meals in category
      final countryMeals = await fetchMealsByCountry(country);

      // If no search query, return all category meals
      if (query.isEmpty) return countryMeals;

      // Then search within these meals
      final searchResults = await searchMealsByName(query);

      // Filter to only include meals that are in both lists
      final countryMealsId = countryMeals.map((m) => m.id).toSet();
      return searchResults.where((m) => countryMealsId.contains(m.id)).toList();
    } catch (e) {
      throw _handleError('meals by name and country', e);
    }
  }

  // Helper methods
  Meal? _handleMealResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('Failed to load data: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['meals'] == null || (data['meals'] as List).isEmpty) {
      return null;
    }

    return _parseMealFromJson(data['meals'][0]);
  }

  List<T> _handleListResponse<T>(
      http.Response response,
      String listKey,
      T Function(Map<String, dynamic>) fromJson,
      ) {
    if (response.statusCode != 200) {
      throw Exception('Failed to load data: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data[listKey] == null) {
      return [];
    }

    return (data[listKey] as List).map((json) => fromJson(json)).toList();
  }

  List<Meal> _handleFilteredMealsResponse(
      http.Response response, {
        String? category,
        String? country,
      }) {
    if (response.statusCode != 200) {
      throw Exception('Failed to load data: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['meals'] == null) {
      return [];
    }

    return (data['meals'] as List).map((json) {
      return Meal(
        id: json['idMeal'] ?? '',
        name: json['strMeal'] ?? 'Unknown Meal',
        imageUrl: json['strMealThumb'] ?? '',
        instructions: null,
        category: category ?? json['strCategory'] ?? '',
        originCountry: country ?? json['strArea'] ?? '',
        youtubeUrl: null,
        ingredients: [],
      );
    }).toList();
  }

  List<Meal> _handleFullMealsResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('Failed to load data: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['meals'] == null) {
      return [];
    }

    return (data['meals'] as List)
        .map((json) => _parseMealFromJson(json))
        .toList();
  }

  Meal _parseMealFromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];

    for (var i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'] as String?;
      final measure = json['strMeasure$i'] as String?;

      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ingredients.add(
          '${measure?.trim() ?? ''} ${ingredient.trim()}'.trim(),
        );
      }
    }

    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? 'Unknown Meal',
      imageUrl: json['strMealThumb'] ?? '',
      instructions: json['strInstructions'],
      category: json['strCategory'] ?? '',
      originCountry: json['strArea'],
      youtubeUrl: json['strYoutube'],
      ingredients: ingredients,
    );
  }

  Exception _handleError(String operation, dynamic error) {
    print('Error fetching $operation: $error');
    return Exception('Failed to load $operation: ${error.toString()}');
  }
}