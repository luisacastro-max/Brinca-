import 'package:flutter/material.dart';

import '../design_system/components/age_grid/age_grid.dart';
import '../design_system/components/age_grid/age_grid_vm.dart';

class AgeGrid extends StatelessWidget {
  final int? selectedIndex;
  final Function(int) onSelectAge;

  const AgeGrid({
    super.key,
    required this.selectedIndex,
    required this.onSelectAge,
  });

  static const ageLabels = [
    "0-1 ano",
    "1-2 anos",
    "2-3 anos",
    "3-4 anos",
    "4-5 anos",
    "5-6 anos",
    "6-7 anos",
    "7-8 anos",
    "8-9 anos",
  ];

  @override
  Widget build(BuildContext context) {
    return AgeGridComponent.instantiate(
      viewModel: AgeGridViewModel(
        selectedIndex: selectedIndex,
        onSelectAge: onSelectAge,
        ageLabels: ageLabels,
      ),
    );
  }
}
