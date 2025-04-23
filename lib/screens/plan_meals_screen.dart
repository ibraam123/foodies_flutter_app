import 'package:flutter/material.dart';
import 'package:foodies2_flutter_app/constants.dart';
import 'package:foodies2_flutter_app/screens/search_screen.dart';
import 'package:provider/provider.dart';
import '../models/plan_meal_model.dart';
import '../providers/planned_meals_provider.dart';
import '../widgets/custom_widgets/custom_bottom_navigation_bar.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';

class PlanMealsScreen extends StatefulWidget {
  const PlanMealsScreen({super.key});
  static String id = 'PlanMealsScreen';

  @override
  State<PlanMealsScreen> createState() => _PlanMealsScreenState();
}

class _PlanMealsScreenState extends State<PlanMealsScreen> {


  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (_selectedIndex == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      } else if (_selectedIndex == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FavoritesScreen()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Load planned meals when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlannedMealsProvider>(context, listen: false).loadPlannedMeals();
    });
  }

  // Custom widget for each day section
  Widget _buildDaySection(String dayName, List<PlannedMeal> meals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          dayName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
            fontSize: 20,
          ),
        ),
        Divider(
          color: Colors.grey.shade300,
          thickness: 1,
          height: 16,
          indent: 5,
          endIndent: 5,
        ),

        if (meals.isEmpty)
          Container(
            height: 100,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'No meals planned for $dayName',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ),
          )
        else
          Column(
            children: meals.map((meal) => _buildMealItem(meal)).toList(),
          ),
      ],
    );
  }

  Widget _buildMealItem(PlannedMeal meal) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: meal.imageUrl != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            meal.imageUrl!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        )
            : Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.fastfood, color: Colors.grey.shade400),
        ),
        title: Text(
          meal.name!,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            Provider.of<PlannedMealsProvider>(context, listen: false)
                .removeMealFromPlan(meal.mealId, meal.day!);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plannedMealsProvider = Provider.of<PlannedMealsProvider>(context);
    final plannedMeals = plannedMealsProvider.plannedMealsByDay;

    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Plan Meals of Week',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<PlannedMealsProvider>(context, listen: false).loadPlannedMeals();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            _buildDaySection('Monday', plannedMeals['Monday'] ?? []),
            _buildDaySection('Tuesday', plannedMeals['Tuesday'] ?? []),
            _buildDaySection('Wednesday', plannedMeals['Wednesday'] ?? []),
            _buildDaySection('Thursday', plannedMeals['Thursday'] ?? []),
            _buildDaySection('Friday', plannedMeals['Friday'] ?? []),
            _buildDaySection('Saturday', plannedMeals['Saturday'] ?? []),
            _buildDaySection('Sunday', plannedMeals['Sunday'] ?? []),
          ],
        ),
      ),
    );
  }
}