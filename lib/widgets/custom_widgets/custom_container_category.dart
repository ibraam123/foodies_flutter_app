import 'package:flutter/material.dart';

import '../../models/category_model.dart';

class CustomContainerCategory extends StatelessWidget {
  final Category category;

  const CustomContainerCategory({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(right: 10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              category.imageUrl,
              height: 70,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5),
          Text(
            category.name,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
