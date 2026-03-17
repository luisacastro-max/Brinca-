import 'package:flutter/material.dart';

import 'gradient_progress_bar_vm.dart';

class GradientProgressBarComponent extends StatelessWidget {
  final GradientProgressBarViewModel viewModel;

  const GradientProgressBarComponent._({super.key, required this.viewModel});

  static Widget instantiate({
    Key? key,
    required GradientProgressBarViewModel viewModel,
  }) {
    return GradientProgressBarComponent._(key: key, viewModel: viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: viewModel.borderRadius,
      child: SizedBox(
        height: viewModel.height,
        child: Stack(
          children: [
            Container(
              color: viewModel.backgroundColor,
            ),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: viewModel.normalizedProgress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: viewModel.gradientColors),
                  borderRadius: viewModel.borderRadius,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
