import 'package:app_twins/pages/clinic_home_page/clinic_home_page_service.dart';
import 'package:flutter/material.dart';

class ClinicAttentionItemTile extends StatelessWidget {
  const ClinicAttentionItemTile({
    super.key,
    required this.childName,
    required this.ageLabel,
    required this.message,
    required this.priority,
  });

  final String childName;
  final String ageLabel;
  final String message;
  final ClinicAttentionPriority priority;

  @override
  Widget build(BuildContext context) {
    final isHigh = priority == ClinicAttentionPriority.high;

    final backgroundColor = isHigh ? const Color(0xFFFEF2F2) : const Color(0xFFFFF7ED);
    final borderColor = isHigh ? const Color(0xFFFFC9C9) : const Color(0xFFFFD6A8);
    final dotColor = isHigh ? const Color(0xFFFB2C36) : const Color(0xFFFF6900);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 7),
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  childName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF101828),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ageLabel,
                  style: const TextStyle(
                    color: Color(0xFF4A5565),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFF364153),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
