import 'package:flutter/material.dart';

import '../constants.dart';

class PasswordTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const PasswordTextField({
    super.key,
    this.labelText = 'Enter Your Password',
    this.controller,
    this.onChanged,
    this.validator,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      style: const TextStyle(fontSize: 16),
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: kPrimaryColor),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: kPrimaryColor,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
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
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}

