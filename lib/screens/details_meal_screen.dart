import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/favorite_meal_model.dart';
import '../models/meal_model.dart';
import '../providers/favorite_meals_provider.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({super.key, required this.mealId});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  late Future<Meal> _mealFuture;
  YoutubePlayerController? _youtubeController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _mealFuture = ApiService().fetchMealById(widget.mealId);
  }

  void _initializeYoutubeController(String? youtubeUrl) {
    if (youtubeUrl != null && youtubeUrl.isNotEmpty) {
      final videoId = YoutubePlayer.convertUrlToId(youtubeUrl);
      if (videoId != null && videoId.isNotEmpty) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            enableCaption: true,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final favoritesProvider = Provider.of<FavoritesProvider>(context);


    return FutureBuilder<Meal>(
      future: _mealFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text('Meal not found')));
        }

        final meal = snapshot.data!;
        _initializeYoutubeController(meal.youtubeUrl);

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Image with Back and Favorite Buttons
                Stack(
                  children: [
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(meal.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              // Toggle favorite state
                              final meal_fav = FavoriteMeal(
                                id: widget.mealId,
                                name:  meal.name,
                                imageUrl: meal.imageUrl,
                                category: meal.category,
                              );
                              favoritesProvider.toggleFavorite(meal_fav);
                              _isFavorite = !_isFavorite;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meal Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              meal.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Origin Country
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.flag,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              meal.originCountry ?? 'Unknown origin',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),


                      const Divider(height: 30),

                      // Ingredients Header
                      const Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Ingredients List or fallback
                      if (meal.ingredients.isEmpty ?? true)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('No ingredients available.'),
                        )
                      else
                        ...meal.ingredients.map(
                          (ingredient) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.circle, size: 8),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    ingredient,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const Divider(height: 30),

                      // Instructions Header
                      const Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // YouTube Video if available
                      if (_youtubeController != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: YoutubePlayer(
                            controller: _youtubeController!,
                            showVideoProgressIndicator: true,
                            progressColors: const ProgressBarColors(
                              playedColor: Colors.red,
                              handleColor: Colors.redAccent,
                            ),
                          ),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('No video available.'),
                        ),

                      // Instructions Text
                      Text(
                        meal.instructions?.isNotEmpty == true
                            ? meal.instructions!
                            : 'No instructions provided.',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
