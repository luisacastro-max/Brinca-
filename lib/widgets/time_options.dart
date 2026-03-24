import 'package:flutter/material.dart';

import '../design_system/components/time_options/time_options.dart';
import '../design_system/components/time_options/time_options_vm.dart';

class TimeOptions extends StatelessWidget {
  final int? selectedIndex;
  final Function(int) onSelectTime;

  const TimeOptions({
    super.key,
    required this.selectedIndex,
    required this.onSelectTime,
  });

  static const timeLabels = [
    "Menos de 10 minutos",
    "10-20 minutos",
    "20-30 minutos",
    "30-60 minutos",
    "Mais de 60 minutos",
  ];

  @override
  Widget build(BuildContext context) {
    return TimeOptionsComponent.instantiate(
      viewModel: TimeOptionsViewModel(
        selectedIndex: selectedIndex,
        onSelectTime: onSelectTime,
        timeLabels: timeLabels,
      ),
    );
  }
}
