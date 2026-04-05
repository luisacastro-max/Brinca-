import 'package:flutter/material.dart';

class BulletListSection extends StatelessWidget {
  const BulletListSection({
    super.key,
    required this.title,
    required this.items,
    required this.emptyMessage,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  final String title;
  final List<String> items;
  final String emptyMessage;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF0A0A0A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (items.isEmpty)
            Text(
              emptyMessage,
              style: const TextStyle(fontSize: 14, color: Color(0xFF667085)),
            )
          else
            Column(
              children: [
                for (final item in items)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.radio_button_checked_outlined,
                          size: 24,
                          color: Color(0xFF2B7FFF),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1E2939),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
