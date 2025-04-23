import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodies2_flutter_app/providers/favorite_meals_provider.dart';
import 'package:foodies2_flutter_app/providers/meal_provider.dart';
import 'package:foodies2_flutter_app/providers/planned_meals_provider.dart';
import 'package:foodies2_flutter_app/screens/favorites_screen.dart';
import 'package:foodies2_flutter_app/screens/plan_meals_screen.dart';
import 'package:foodies2_flutter_app/screens/search_screen.dart';
import 'package:foodies2_flutter_app/services/hive_service.dart';
import 'package:foodies2_flutter_app/screens/auth/login_screen.dart';
import 'package:foodies2_flutter_app/screens/auth/signup_screen.dart';
import 'package:foodies2_flutter_app/screens/home_screen.dart';
import 'package:foodies2_flutter_app/screens/stratup_screens/first_screen.dart';
import 'package:foodies2_flutter_app/screens/stratup_screens/second_screen.dart';
import 'package:foodies2_flutter_app/screens/stratup_screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MealProvider()),
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
        ChangeNotifierProvider(create: (context) => PlannedMealsProvider()),
      ],
      child: const FoodiesApp(),
    ),
  );
}

class FoodiesApp extends StatelessWidget {
  const FoodiesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // add const
      theme: ThemeData.light(useMaterial3: true),
      title: 'Foodies',
      initialRoute: SplashScreen.id,
// main.dart
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        FirstScreen.id: (context) => const FirstScreen(),
        SecondScreen.id: (context) => const SecondScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignupScreen.id: (context) => const SignupScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        SearchScreen.id: (context) => const SearchScreen(),
        FavoritesScreen.id: (context) => const FavoritesScreen(),
        PlanMealsScreen.id: (context) => const PlanMealsScreen(),
      },
    );
  }
}