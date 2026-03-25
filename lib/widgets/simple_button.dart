import 'package:flutter/material.dart';

import '../design_system/components/simple_button/simple_button.dart';
import '../design_system/components/simple_button/simple_button_vm.dart';

class SimpleButton extends StatelessWidget {
  final String label;
  final bool isFullWidth;

  const SimpleButton({
    super.key,
    required this.label,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleButtonComponent.instantiate(
      viewModel: SimpleButtonViewModel(
        label: label,
        isFullWidth: isFullWidth,
      ),
    );
  }
}
