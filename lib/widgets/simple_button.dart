import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  final String label;
  final bool isFullWidth;

  const SimpleButton({
    super.key,
    required this.label,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isFullWidth ? 50 : null,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: isFullWidth ? 14 : 13,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
