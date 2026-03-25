import 'package:flutter/material.dart';

class ChildNameFieldViewModel {
  final String label;
  final String hintText;
  final TextEditingController? controller;

  const ChildNameFieldViewModel({
    this.label = 'Nome da criança',
    this.hintText = 'Digite o nome...',
    this.controller,
  });
}
