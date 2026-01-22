import 'package:app_twins/theme/theme_data_base.dart';
import 'package:flutter/material.dart';

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
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 75,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFCA1AA),
                            Color(0xFFFFD54F),
                            Color(0xFFA8D8BB),
                            Color(0xFF7AA4E3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 25,
                    child: Container(
                      color: Colors.grey[200],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

