import 'package:flutter/material.dart';

class PasswordVisibilityToggle extends StatelessWidget {
  final bool obscureText;
  final VoidCallback? onPressed;

  const PasswordVisibilityToggle({
    super.key,
    required this.obscureText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
      onPressed: onPressed,
    );
  }
}
