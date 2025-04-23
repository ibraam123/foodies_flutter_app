import 'package:flutter/material.dart';
import 'package:foodies2_flutter_app/screens/auth/signup_screen.dart';
import '../../constants.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_widgets/custom_button.dart';
import '../../widgets/custom_widgets/custom_text_field.dart';
import '../../widgets/password_text_fiels.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String id = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Instance of the authentication service for handling login operations.
  final AuthService _auth = AuthService();
  // Controllers for the email and password text fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Boolean to track loading state during login/sign-in.
  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose the controllers when the widget is removed from the tree
    // to prevent memory leaks.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      // Set loading to true when starting the login process.
      _isLoading = true;
    });

    // Get the email and password from the text fields.
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validate that both email and password fields are not empty.
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      setState(() {
        // Set loading to false if validation fails.
        _isLoading = false;
      });
      // Return early to prevent further execution if validation fails.
      // Return early to prevent further execution if validation fails.
      return;
    }

    try {
      final user = await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please check your credentials.')),
        );
      }
      // Display error message in a snackbar if login fails.
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
        // Set loading to false regardless of success or failure.
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      // Set loading to true when starting the Google sign-in process.
    });

    try {
      final user = await _auth.signInWithGoogle();
      if (user != null) {
        // If sign-in is successful, navigate to the home screen.
        Navigator.pushReplacementNamed(context, HomeScreen.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed in with Google successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign in failed')),
          // Display message in a snackbar if Google sign-in fails.
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error with Google sign in: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
        // Set loading to false regardless of success or failure.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive UI adjustments.
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : SingleChildScrollView(
        // Show loading indicator if _isLoading is true.
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
                    labelText: 'Enter Your Email',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),
                  PasswordTextField(
                    labelText: 'Enter Your Password',
                    controller: _passwordController,
                  ),
                  _buildForgotPasswordLink(),
                  const SizedBox(height: 10),
                  CustomButton(
                    onPressed: _login,
                    buttonText: 'Login',
                    color: kPrimaryColor,
                  ),
                  SizedBox(height: 15),
                  CustomButton(
                    onPressed: _signInWithGoogle,
                    buttonText: 'Sign in with Google',
                    color: Colors.red,
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(color: kPrimaryColor, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignupScreen.id);
                    },
                    child: Text(
                      'Create new account',
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
                  'Welcome Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Add forgot password logic here
        },
        child: Text('Forgot Password?', style: TextStyle(color: kPrimaryColor)),
      ),
    );
  }
}


