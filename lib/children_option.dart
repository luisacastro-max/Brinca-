import 'package:flutter/material.dart';

import 'design_system/components/children_option/children_option.dart';
import 'design_system/components/children_option/children_option_vm.dart';

class ChildrenOption extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const ChildrenOption({
    super.key,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChildrenOptionComponent.instantiate(
      viewModel: ChildrenOptionViewModel(
        label: label,
        color: color,
        selected: selected,
        onTap: onTap,
      ),
    );
  }
}

