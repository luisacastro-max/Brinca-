import 'package:flutter/material.dart';

import '../design_system/components/child_name_field/child_name_field.dart';
import '../design_system/components/child_name_field/child_name_field_vm.dart';

class ChildNameField extends StatelessWidget {
  const ChildNameField({
    super.key,
    this.controller,
  });

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return ChildNameFieldComponent.instantiate(
      viewModel: ChildNameFieldViewModel(controller: controller),
    );
  }
}
