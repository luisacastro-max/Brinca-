import 'package:flutter/material.dart';

import 'auth_text_field_vm.dart';

class AuthTextFieldComponent extends StatelessWidget {
  final AuthTextFieldViewModel viewModel;

  const AuthTextFieldComponent._({super.key, required this.viewModel});

  static Widget instantiate({
    Key? key,
    required AuthTextFieldViewModel viewModel,
  }) {
    return AuthTextFieldComponent._(key: key, viewModel: viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: viewModel.controller,
      keyboardType: viewModel.keyboardType,
      obscureText: viewModel.isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(viewModel.icon, color: Colors.grey.shade400, size: 20),
        hintText: viewModel.hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF8FBFB),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFA8E6CF), width: 1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
