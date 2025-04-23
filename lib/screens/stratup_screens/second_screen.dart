import 'package:flutter/material.dart';
import 'package:foodies2_flutter_app/screens/home_screen.dart';

// Import the authentication service.
import '../../services/auth_service.dart';
// Import the custom intro widget.
import '../../widgets/intro_widget.dart';
// Import the login screen.
import '../auth/login_screen.dart';

// This screen is displayed on the app's startup.
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  // A unique identifier for this screen, used for navigation.
  static String id = 'SecondScreen';

  @override
  Widget build(BuildContext context) {
    // Create an instance of the AuthService.
    final AuthService auth = AuthService();

    return Scaffold(
      backgroundColor: Colors.white,
      body: IntroWidget(
        // Set the title text for the intro screen.
        title: 'All Your Favorites',
        // Set the description text for the intro screen.
        description: 'Get all your loved foods in one once place',
        // Set the image for the intro screen using a Lottie animation.
        image: 'assets/lottie/secondlottie.json',
        // Set the text for the button on the intro screen.
        buttonText: 'Get Started',
        // Define the action to be performed when the button is pressed.
        onPressed: () {
          // Check if a user is currently logged in.
          if (auth.currentUser != null) {
            // If a user is logged in, navigate to the home screen.
            Navigator.pushNamed(context, HomeScreen.id);
          } else {
            // If no user is logged in, navigate to the login screen.
            Navigator.pushNamed(context, LoginScreen.id);
          }
        },
      ),
    );
  }
}
