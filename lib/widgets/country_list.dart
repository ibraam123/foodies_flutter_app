
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/area_model.dart';
import 'custom_widgets/custome_container_area.dart';
class CountryList extends StatelessWidget {
  // List of countries to display
  final List<Country> countries;
  // Callback function when a country is tapped
  final Function(String) onCountryTap;

  const CountryList({
    super.key,
    // Required list of countries
    required this.countries,
    // Required function to be called when a country is tapped
    required this.onCountryTap,
  });

  @override
  Widget build(BuildContext context) {
    // Container for the list view with a fixed height
    return SizedBox(
      height: 120,
      // Horizontal list view builder
      child: ListView.builder(
        // Set the scroll direction to horizontal
        scrollDirection: Axis.horizontal,
        // Number of items to build
        itemCount: countries.length,
        // Builder for each item in the list
        itemBuilder: (context, index) {
          // Current country from the list
          final country = countries[index];
          // Fetch the flag URL or default to UN flag
          final flagUrl =
              countryFlagUrls[country.name] ??
                  'https://flagcdn.com/w40/un.png'; // Default to UN flag
          // Gesture detector to handle tap on each country item
          return GestureDetector(
            onTap: () => onCountryTap(country.name),
            child: CustomeContainerArea(country: country, imageUrl: flagUrl),
          );
        },
      ),
    );  }
}
