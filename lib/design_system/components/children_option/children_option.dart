import 'package:flutter/material.dart';

import 'children_option_vm.dart';

class ChildrenOptionComponent extends StatelessWidget {
  final ChildrenOptionViewModel viewModel;

  const ChildrenOptionComponent._({super.key, required this.viewModel});

  static Widget instantiate({
    Key? key,
    required ChildrenOptionViewModel viewModel,
  }) {
    return ChildrenOptionComponent._(key: key, viewModel: viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: viewModel.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: viewModel.selected
              ? const LinearGradient(
                  colors: [
                    Color(0xFFFCA1AA),
                    Color(0xFF7AA4E3),
                    Color(0xFFA8D8BB),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: viewModel.selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: viewModel.color,
            width: 2,
          ),
          boxShadow: viewModel.selected
              ? [
                  BoxShadow(
                    color: viewModel.color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          viewModel.label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: viewModel.selected ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
