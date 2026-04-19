import 'package:flutter/material.dart';

class DevelopmentMetricCard extends StatelessWidget {
  const DevelopmentMetricCard({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.deltaPercent,
    this.valueColor,
    this.highlightText,
    this.highlightColor,
    this.trailingText,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String value;
  final int deltaPercent;
  final Color? valueColor;
  final String? highlightText;
  final Color? highlightColor;
  final String? trailingText;

  @override
  Widget build(BuildContext context) {
    final effectiveHighlightColor = highlightColor ?? _comparisonColor(deltaPercent);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE3EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Color(0xFF4A5565)),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: valueColor ?? const Color(0xFF101828),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                highlightText ?? '$deltaPercent% ',
                style: TextStyle(
                  fontSize: 14,
                  color: effectiveHighlightColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                trailingText ?? 'vs periodo anterior',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6A7282),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _comparisonColor(int score) {
    if (score > 50) return const Color(0xFF0F9D58);
    if (score < 50) return const Color(0xFFE4572E);
    return const Color(0xFF6A7282);
  }
}
