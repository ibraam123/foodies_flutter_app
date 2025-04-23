import 'package:flutter/material.dart';

import '../providers/meal_provider.dart';

class CategorySelectionDialog extends StatelessWidget {
  final MealProvider mealProvider;
  final Function(String) onCategoryTap;

  const CategorySelectionDialog({
    super.key,
    required this.mealProvider,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Category',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCategoryList(),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text('Close'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    if (mealProvider.isLoading && mealProvider.categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (mealProvider.categories.isEmpty) {
      return const Center(child: Text("No categories found"));
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: mealProvider.categories.map((category) {
        return GestureDetector(
          onTap: () => onCategoryTap(category.name),
          child: Chip(
            label: Text(category.name),
            backgroundColor: Colors.grey[200],
          ),
        );
      }).toList(),
    );
  }
}
