import 'package:flutter/material.dart';
import 'package:foodies2_flutter_app/screens/stratup_screens/second_screen.dart';
import '../../widgets/intro_widget.dart';
/// The first screen displayed in the app, part of the startup sequence.
/// It introduces the app's meal planning feature to the user.
class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  /// A static identifier for navigation purposes.
  static String id = 'FirstScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /// Uses a custom `IntroWidget` to display an introduction with an image,
      /// title, description, and a button.
      body: IntroWidget(
        title: 'Plan Your Meals',
        description:
            'Organize your meals in advance, save time, eat healthier and happier',
        image: 'assets/lottie/firstlottie.json',
        /// The path to the Lottie animation file displayed on this screen.

        buttonText: 'Next',
        /// Defines the action to take when the "Next" button is pressed.
        /// In this case, it navigates to the `SecondScreen` using its static ID.
        /// `Navigator.pushNamed` is used for named route navigation.
        onPressed: () {
          Navigator.pushNamed(context, SecondScreen.id);
        },
      ),
    );
  }
}
