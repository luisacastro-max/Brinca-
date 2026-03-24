import 'package:flutter/material.dart';

class ChildrenOptionViewModel {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const ChildrenOptionViewModel({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });
}
