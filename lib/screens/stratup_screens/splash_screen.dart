import 'dart:async';

// Import the Flutter Material library for UI elements
import 'package:flutter/material.dart';
// Import the Lottie library for displaying Lottie animations
import 'package:lottie/lottie.dart';

// Import the next screen to navigate to after the splash screen
import 'first_screen.dart';

// Define the SplashScreen widget as a StatefulWidget, allowing for state changes
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  // Define a static ID for the SplashScreen, used for navigation
  static String id = 'SplashScreen';

  // Override the createState method to return the state of the SplashScreen
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Define the state for the SplashScreen
class _SplashScreenState extends State<SplashScreen> {
  // Declare a Timer variable to manage the delay
  Timer? _timer;

  // Define a function to navigate to the next screen
  void _goNext() {
    // Use Navigator to replace the current screen (splash screen) with the FirstScreen
    Navigator.pushReplacementNamed(
      context,
      FirstScreen.id,
    );
  }

  // Override the initState method, called when the widget is created
  @override
  void initState() {
    super.initState();
    // Initialize the timer to call _goNext after a 3-second delay
    _timer = Timer(const Duration(seconds: 3), _goNext);
  }

  // Override the build method to define the UI of the SplashScreen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Center(
        child: Lottie.asset(
          'assets/lottie/startlottieaplash.json',
          width: double.infinity,
          height: 230,
          fit: BoxFit.contain, // Ensure the Lottie animation fits within its bounds
        ),
      ),
    );
  }

  // Override the dispose method to clean up resources when the widget is removed
  @override
  void dispose() {
    // Cancel the timer to prevent memory leaks
    _timer?.cancel();
    super.dispose();
  }
}
