import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';
import 'custom_widgets/custom_button.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.buttonText,
    required this.onPressed,
  });

  final String title;
  final String description;

  final String image;

  final String buttonText;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 350,
            width: double.infinity,
            child: Lottie.asset(
              image,
              repeat: false,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              description,
              style: TextStyle(color: Colors.black, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 50),
          CustomButton(
            onPressed: onPressed,
            buttonText: buttonText,
            color: kPrimaryColor,
          ),
        ],
      ),
    );
  }
}
