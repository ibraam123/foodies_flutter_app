

// Example Hive model for planned meals
import 'package:hive/hive.dart';
part 'plan_meal_model.g.dart';

@HiveType(typeId: 1)
class PlannedMeal extends HiveObject {
  @HiveField(0)
  final String mealId;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final String? day;



  PlannedMeal({
    required this.mealId,
    required this.name,
    required this.imageUrl,
    required this.day,
  });
}
