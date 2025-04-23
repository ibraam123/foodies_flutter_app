import 'package:flutter/material.dart';

import '../providers/meal_provider.dart';

class CountrySelectionDialog extends StatelessWidget {
  final MealProvider mealProvider;
  final Function(String) onCountryTap;

  const CountrySelectionDialog({
    super.key,
    required this.mealProvider,
    required this.onCountryTap,
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
              'Select Country',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCountryList(),
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

  Widget _buildCountryList() {
    if (mealProvider.isLoading && mealProvider.countries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (mealProvider.countries.isEmpty) {
      return const Center(child: Text("No countries found"));
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: mealProvider.countries.map((country) {
        return GestureDetector(
          onTap: () => onCountryTap(country.name),
          child: Chip(
            label: Text(country.name),
            backgroundColor: Colors.grey[200],
          ),
        );
      }).toList(),
    );
  }
}