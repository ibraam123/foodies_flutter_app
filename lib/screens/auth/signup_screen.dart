import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_widgets/custom_button.dart'; // Custom button widget
import '../../widgets/custom_widgets/custom_text_field.dart'; // Custom text field widget
import '../home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static String id = 'SignupScreen'; // Route ID for navigation
  static String? firstName; // Static variable to store the user's first name temporarily

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Instance of the authentication service
  final AuthService _auth = AuthService();

  // Text editing controllers for the input fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // State variables
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the tree to prevent memory leaks
    _firstNameController.dispose();
    _secondNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // This is called when the stateful widget is inserted in the tree.
    // Useful place for initial setup that depends on the state object itself.
    super.initState();
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    final firstName = _firstNameController.text.trim();
    final secondName = _secondNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Input validation: check if any field is empty
    if (firstName.isEmpty || secondName.isEmpty || email.isEmpty ||
        password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Check if the passwords match
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Store the first name for later use
    // This is a temporary solution, ideally user data should be managed in a database
    SignupScreen.firstName = firstName;

    try {
      // Attempt to sign up the user using the authentication service
      final user = await _auth.signUpWithEmailAndPassword(email, password);

      // If the signup was successful
      if (user != null) {
        // Display a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );

        // Navigate to the home screen, replacing the current screen
        // to prevent going back to the signup screen

        Navigator.pushReplacementNamed(context, HomeScreen.id);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign up failed. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) { // Builds the user interface
    Size size = MediaQuery.of(context).size; // Get the screen size

    return Scaffold( // Base for visual elements
      // Sets background to white
      // If loading, show indicator, else display the content
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(size),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    labelText: 'First Name',
                    controller: _firstNameController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    labelText: 'Second Name',
                    controller: _secondNameController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    labelText: 'Enter Your Email',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                    labelText: 'Enter Your Password',
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                    labelText: 'Confirm Your Password',
                    controller: _confirmPasswordController,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    onPressed: _signUp,
                    buttonText: 'Sign Up',
                    color: kPrimaryColor,
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: kPrimaryColor, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== Widgets Breakdown ==========

  Widget _buildHeader(Size size) {
    return Container(
      width: double.infinity,
      height: size.height * 0.33,
      decoration: BoxDecoration(color: kPrimaryColor),
      child: Stack(
        children: [
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({required String labelText, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      style: const TextStyle(fontSize: 16),
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: kPrimaryColor),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: kPrimaryColor,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}