import 'package:flutter/material.dart';

class InputFieldViewModel {
  final TextEditingController controller;
  final String placeholder;
  final bool isEnabled;
  bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final VoidCallback? isPasswordVisible;

  InputFieldViewModel({
    required this.controller,
    required this.placeholder,
    required this.isEnabled,
    required this.isPassword,
    this.prefixIcon,
    this.suffixIcon,
    this.isPasswordVisible,
    this.validator
  });
}