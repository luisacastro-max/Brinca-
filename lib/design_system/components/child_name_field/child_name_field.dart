import 'package:app_twins/theme/theme_data_base.dart';
import 'package:flutter/material.dart';

import 'child_name_field_vm.dart';

class ChildNameFieldComponent extends StatelessWidget {
  final ChildNameFieldViewModel viewModel;

  const ChildNameFieldComponent._({super.key, required this.viewModel});

  static Widget instantiate({
    Key? key,
    required ChildNameFieldViewModel viewModel,
  }) {
    return ChildNameFieldComponent._(key: key, viewModel: viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(viewModel.label, style: containerTextStyle),
        const SizedBox(height: 10),
        TextField(
          controller: viewModel.controller,
          decoration: InputDecoration(
            hintText: viewModel.hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
