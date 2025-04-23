import 'package:flutter/material.dart';

import '../models/area_model.dart';
import '../models/category_model.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart';

enum FilterType { none, category, country }

class MealProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Meal? _randomMeal;
  List<Category> _categories = [];
  List<Country> _countries = [];
  List<Meal> _categoryMeals = [];
  List<Meal> _countryMeals = [];
  List<Meal> _searchResults = [];
  List<Meal> _filteredMeals = [];

  List<Meal> get filteredMeals => _filteredMeals;

  bool isLoadingRandomMeal = false;
  bool isLoadingCategories = false;
  bool isLoadingCountries = false;
  bool isLoadingCategoryMeals = false;
  bool isLoadingCountryMeals = false;
  bool isLoadingSearch = false;

  String? _error;

  Meal? get randomMeal => _randomMeal;

  List<Category> get categories => _categories;

  List<Country> get countries => _countries;

  List<Meal> get categoryMeals => _categoryMeals;

  List<Meal> get countryMeals => _countryMeals;

  String? get error => _error;

  List<Meal> get searchResults => _searchResults;

  String? _selectedCategory;

  String? get selectedCategory => _selectedCategory;

  String? _selectedCountry;

  String? get selectedCountry => _selectedCountry;

  // Track active filter type
  FilterType _activeFilterType = FilterType.none;

  FilterType get activeFilterType => _activeFilterType;

  // General loading state
  bool get isLoading {
    return isLoadingRandomMeal ||
        isLoadingCategories ||
        isLoadingCountries ||
        isLoadingCategoryMeals ||
        isLoadingCountryMeals ||
        isLoadingSearch;
  }

  Future<void> searchMeals(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    await _loadData<List<Meal>>(
      apiCall: () => _apiService.searchMealsByName(query),
      onSuccess: (data) {
        _searchResults = data;

        // Apply additional filtering if needed
        if (_selectedCategory != null) {
          _filteredMeals =
              data.where((meal) => meal.category == _selectedCategory).toList();
        } else if (_selectedCountry != null) {
          _filteredMeals =
              data
                  .where((meal) => meal.originCountry == _selectedCountry)
                  .toList();
        } else {
          _filteredMeals = data;
        }
      },
      setLoading: (isLoading) => isLoadingSearch = isLoading,
    );
  }

  Future<void> searchMealsByCategory(String query, String category) async {
    if (query.isEmpty) {
      await loadMealsByCategory(category);
      return;
    }

    await _loadData<List<Meal>>(
      apiCall: () => _apiService.searchMealsByNameAndCategory(query, category),
      onSuccess: (data) {
        _searchResults = data;
        _categoryMeals = data;
        _filteredMeals = data;
        _selectedCategory = category;
        _selectedCountry = null;
        _activeFilterType = FilterType.category;
      },
      setLoading: (isLoading) => isLoadingSearch = isLoading,
    );
  }

  Future<void> searchMealsByCountry(String query, String country) async {
    if (query.isEmpty) {
      await loadMealsByCountry(country);
      return;
    }

    await _loadData<List<Meal>>(
      apiCall: () => _apiService.searchMealsByNameAndCountry(query, country),
      onSuccess: (data) {
        _searchResults = data;
        _countryMeals = data;
        _filteredMeals = data;
        _selectedCountry = country;
        _selectedCategory = null;
        _activeFilterType = FilterType.country;
      },
      setLoading: (isLoading) => isLoadingSearch = isLoading,
    );
  }

  void clearFilters() {
    _selectedCategory = null;
    _selectedCountry = null;
    _activeFilterType = FilterType.none;
    _filteredMeals = [];
    notifyListeners();
  }

  void clearCategoryFilter() {
    _selectedCategory = null;
    if (_activeFilterType == FilterType.category) {
      _activeFilterType = FilterType.none;
      _filteredMeals = [];
    }
    notifyListeners();
  }

  void clearCountryFilter() {
    _selectedCountry = null;
    if (_activeFilterType == FilterType.country) {
      _activeFilterType = FilterType.none;
      _filteredMeals = [];
    }
    notifyListeners();
  }

  // Load initial data (can be used when clearing filters)
  Future<void> loadInitialData() async {
    await Future.wait([loadRandomMeal(), loadCategories(), loadCountries()]);

    // Load meals for first category if available
    if (_categories.isNotEmpty) {
      await loadMealsByCategory(_categories.first.name);
    }
  }

  // Generic loader for single data type (e.g. Meal, List<T>)
  Future<void> _loadData<T>({
    required Future<T> Function() apiCall,
    required void Function(T data) onSuccess,
    required void Function(bool) setLoading,
  }) async {
    setLoading(true);
    _error = null;
    notifyListeners();

    try {
      final data = await apiCall();
      onSuccess(data);
    } catch (e) {
      _error = e.toString();
      print('Error in MealProvider: $_error');
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  // Fetch a random meal
  Future<void> loadRandomMeal() async {
    await _loadData<Meal?>(
      apiCall: _apiService.fetchRandomMeal,
      onSuccess: (data) => _randomMeal = data,
      setLoading: (isLoading) => isLoadingRandomMeal = isLoading,
    );
  }

  // Fetch meal categories
  Future<void> loadCategories() async {
    await _loadData<List<Category>>(
      apiCall: _apiService.fetchCategories,
      onSuccess: (data) => _categories = data,
      setLoading: (isLoading) => isLoadingCategories = isLoading,
    );
  }

  // Fetch countries
  Future<void> loadCountries() async {
    await _loadData<List<Country>>(
      apiCall: _apiService.fetchCountries,
      onSuccess: (data) => _countries = data,
      setLoading: (isLoading) => isLoadingCountries = isLoading,
    );
  }

  // Fetch meals by category
  Future<void> loadMealsByCategory(String category) async {
    await _loadData<List<Meal>>(
      apiCall: () => _apiService.fetchMealsByCategory(category),
      onSuccess: (data) {
        _categoryMeals = data;
        _filteredMeals = data;
        _selectedCategory = category;
        _selectedCountry = null;
        _activeFilterType = FilterType.category;
      },
      setLoading: (isLoading) => isLoadingCategoryMeals = isLoading,
    );
  }

  // Fetch meals by country
  Future<void> loadMealsByCountry(String country) async {
    await _loadData<List<Meal>>(
      apiCall: () => _apiService.fetchMealsByCountry(country),
      onSuccess: (data) {
        _countryMeals = data;
        _filteredMeals = data;
        _selectedCountry = country;
        _selectedCategory = null;
        _activeFilterType = FilterType.country;
      },
      setLoading: (isLoading) => isLoadingCountryMeals = isLoading,
    );
  }

  void filterMealsBySearch(String query) {
    if (query.isEmpty) {
      // Reset to original list based on active filter
      if (_activeFilterType == FilterType.category) {
        _filteredMeals = _categoryMeals;
      } else if (_activeFilterType == FilterType.country) {
        _filteredMeals = _countryMeals;
      } else {
        _filteredMeals = [];
      }
    } else {
      // Apply search filter based on active filter
      if (_activeFilterType == FilterType.category) {
        _filteredMeals =
            _categoryMeals
                .where(
                  (meal) =>
                      meal.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      } else if (_activeFilterType == FilterType.country) {
        _filteredMeals =
            _countryMeals
                .where(
                  (meal) =>
                      meal.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      } else {
        // General search across all meals if no filter
        _filteredMeals =
            _searchResults
                .where(
                  (meal) =>
                      meal.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    }
    notifyListeners();
  }
}
