import 'package:flutter/material.dart';

import 'simple_button_vm.dart';

class SimpleButtonComponent extends StatelessWidget {
  final SimpleButtonViewModel viewModel;

  const SimpleButtonComponent._({super.key, required this.viewModel});

  static Widget instantiate({
    Key? key,
    required SimpleButtonViewModel viewModel,
  }) {
    return SimpleButtonComponent._(key: key, viewModel: viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: viewModel.isFullWidth ? 50 : null,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          viewModel.label,
          style: TextStyle(
            fontSize: viewModel.isFullWidth ? 14 : 13,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
