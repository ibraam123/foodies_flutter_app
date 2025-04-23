import 'package:hive/hive.dart';

part 'favorite_meal_model.g.dart';

@HiveType(typeId: 0)
class FavoriteMeal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final String category;

  FavoriteMeal({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
  });
}