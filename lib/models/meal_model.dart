

class Meal {


  final String id;

  final String name;

  final String imageUrl;

  final String category;

  final String? instructions;

  final String? originCountry;

  final String? youtubeUrl;

  final List<String> ingredients; // List of ingredient measurements (e.g., "1 cup flour")

  Meal({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    this.instructions,
    this.originCountry,
    this.youtubeUrl,
    required this.ingredients,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    // Extract ingredients and measures
    final ingredients = <String>[];
 
    for (var i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add('${measure?.trim() ?? ''} ${ingredient.trim()}'.trim());
      }
    }

    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      imageUrl: json['strMealThumb'],
      category: json['strCategory'] ?? '',
      instructions: json['strInstructions'],
      originCountry: json['strArea'],
      youtubeUrl: json['strYoutube'],
      ingredients: ingredients,
    );
  }
}
