import 'package:flutter/material.dart';

import '../../models/area_model.dart';

class CustomeContainerArea extends StatelessWidget {
  final Country country;
  final String imageUrl;

  const CustomeContainerArea({
    super.key,
    required this.country,
    required this.imageUrl,
  });

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
              imageUrl,
              height: 70,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5),
          Text(
            country.name,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
