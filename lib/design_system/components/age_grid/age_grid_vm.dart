import 'package:flutter/material.dart';

class AgeGridViewModel {
  final int? selectedIndex;
  final ValueChanged<int> onSelectAge;
  final List<String> ageLabels;

  const AgeGridViewModel({
    required this.selectedIndex,
    required this.onSelectAge,
    this.ageLabels = const [
      '0-1 ano',
      '1-2 anos',
      '2-3 anos',
      '3-4 anos',
      '4-5 anos',
      '5-6 anos',
      '6-7 anos',
      '7-8 anos',
      '8-9 anos',
    ],
  });
}
