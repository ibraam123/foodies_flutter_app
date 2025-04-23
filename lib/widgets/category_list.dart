
import 'package:flutter/material.dart';

import '../models/category_model.dart';
import 'custom_widgets/custom_container_category.dart';
class CategoryList extends StatelessWidget {
  final List<Category> categories;
  final Function(String) onCategoryTap;

  const CategoryList({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () => onCategoryTap(category.name),
            child: CustomContainerCategory(category: category),
          );
        },
      ),
    );
  }
}

