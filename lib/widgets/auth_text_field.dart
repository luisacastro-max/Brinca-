import 'package:flutter/material.dart';

import '../design_system/components/auth_text_field/auth_text_field.dart';
import '../design_system/components/auth_text_field/auth_text_field_vm.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return AuthTextFieldComponent.instantiate(
      viewModel: AuthTextFieldViewModel(
        controller: controller,
        hint: hint,
        icon: icon,
        isPassword: isPassword,
        keyboardType: keyboardType,
      ),
    );
  }
}
