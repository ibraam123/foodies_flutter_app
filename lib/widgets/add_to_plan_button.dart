import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/plan_meal_model.dart';
import '../providers/planned_meals_provider.dart';

class AddToPlanButton extends StatelessWidget {
  const AddToPlanButton({super.key, required this.title, required this.mealId, this.imageUrl});
  final String title;
  final String mealId;
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {

    final plannedMealsProvider = Provider.of<PlannedMealsProvider>(context, listen: false);

    return Container(
      width: 150,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: kPrimaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child:ElevatedButton(
        onPressed: () async {
          final selectedDay = await showDialog<String>(
            context: context,
            builder: (context) => SimpleDialog(
              title: Text('Plan "$title" for:'),
              children: [
                for (final day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'])
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, day),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(day),
                    ),
                  ),
              ],
            ),
          );

          if (selectedDay != null  && !plannedMealsProvider.isMealAlreadyExistOnThisDay(mealId, selectedDay) ) {
            final plannedMeal = PlannedMeal(
              mealId: mealId,
              name: title,
              day: selectedDay,
              imageUrl: imageUrl!,
            );

            await plannedMealsProvider.addMealToPlan(plannedMeal);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Added to $selectedDay!')),
            );
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Meal already exist on this day!')),
            );
          }

        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Add to Plan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
