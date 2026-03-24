import 'package:flutter/material.dart';

class TimeOptionsViewModel {
  final int? selectedIndex;
  final ValueChanged<int> onSelectTime;
  final List<String> timeLabels;

  const TimeOptionsViewModel({
    required this.selectedIndex,
    required this.onSelectTime,
    this.timeLabels = const [
      'Menos de 10 minutos',
      '10-20 minutos',
      '20-30 minutos',
      '30-60 minutos',
      'Mais de 60 minutos',
    ],
  });
}
