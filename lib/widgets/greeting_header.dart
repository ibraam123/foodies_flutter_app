import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/stratup_screens/second_screen.dart';
import '../services/auth_service.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName?.split(' ').first ?? 'User';
    String greeting = getGreeting(); // Define a function to return 'Good morning', etc.

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $userName! 👋',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Confirm Logout'),
                  content: Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                    TextButton(
                      child: Text('Logout'),
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close the dialog first

                        try {
                          await AuthService().signOut(); // Sign out
                          Navigator.pushNamed(
                            context,
                            SecondScreen.id,
                          ); // Navigate
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                              title: Text('Error'),
                              content: Text(e.toString()),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(Icons.logout, color: kPrimaryColor, size: 30),
        ),
      ],
    );
  }
}
