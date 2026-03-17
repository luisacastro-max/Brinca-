import 'package:app_twins/theme/theme_data_base.dart';
import 'package:flutter/material.dart';

import '../design_system/components/gradient_progress_bar/gradient_progress_bar.dart';
import '../design_system/components/gradient_progress_bar/gradient_progress_bar_vm.dart';

class ProgressHeader extends StatelessWidget {
  final String step;
  final String percentage;

  const ProgressHeader({
    super.key,
    required this.step,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(step, style: buttonTextStyle.copyWith(color: Colors.blue)),
              Text(percentage, style: buttonTextStyle.copyWith(color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 8),
          GradientProgressBarComponent.instantiate(
            viewModel: GradientProgressBarViewModel(
              progress: 0.75,
              height: 8,
              backgroundColor: Colors.grey[200]!,
              gradientColors: const [
                Color(0xFFFCA1AA),
                Color(0xFF7AA4E3),
                Color(0xFFA8D8BB),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}

