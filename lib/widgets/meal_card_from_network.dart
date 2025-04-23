import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favorite_meal_model.dart';
import '../providers/favorite_meals_provider.dart';
import '../screens/details_meal_screen.dart';
import '../services/hive_service.dart';
import 'add_to_plan_button.dart';

class MealCardFromNetwork extends StatefulWidget {
  final String mealId;
  final String imagePath;
  final String title;
  final String category;


  const MealCardFromNetwork({
    super.key,
    required this.mealId,
    required this.imagePath,
    required this.title,
    this.category = ''
  });

  @override
  State<MealCardFromNetwork> createState() => _MealCardFromNetworkState();
}

class _MealCardFromNetworkState extends State<MealCardFromNetwork> {
  bool isFavorite = false; // Track favorite state

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 600 ? screenWidth * 0.4 : screenWidth * 0.25;
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(widget.mealId);


    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MealDetailScreen(mealId: widget.mealId);
            },
          ),
        );
      },
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 12, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(40),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with favorite button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    widget.imagePath,
                    height: cardWidth * 0.6,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: cardWidth * 0.6,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                // Favorite button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      final meal = FavoriteMeal(
                        id: widget.mealId,
                        name: widget.title,
                        imageUrl: widget.imagePath,
                        category: widget.category,
                      );
                      favoritesProvider.toggleFavorite(meal);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: AddToPlanButton(
                  title: widget.title,
                  mealId: widget.mealId,
                  imageUrl: widget.imagePath,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}