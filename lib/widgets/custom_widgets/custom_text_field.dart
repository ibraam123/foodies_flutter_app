import 'package:flutter/material.dart';
import '../../constants.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.labelText,
    this.onSubmitted,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.showVisibilityToggle = false,
  });

  final String labelText;
  final void Function(String)? onSubmitted;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool showVisibilityToggle;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onSubmitted: widget.onSubmitted,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText && !_isPasswordVisible,
      style: const TextStyle(fontSize: 16),
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: kPrimaryColor),
        suffixIcon: widget.showVisibilityToggle
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: kPrimaryColor,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        )
            : null,
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