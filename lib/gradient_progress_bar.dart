import 'package:flutter/material.dart';

class GradientProgressBar extends StatelessWidget {
  final double progress;

  const GradientProgressBar({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 8,
            color: Colors.grey[300],
          ),
          Container(
            width: MediaQuery.of(context).size.width * progress - 80,
            height: 8,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFCA1AA),
                  Color(0xFF7AA4E3),
                  Color(0xFFA8D8BB),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
