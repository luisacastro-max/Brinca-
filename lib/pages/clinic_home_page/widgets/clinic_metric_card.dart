import 'package:flutter/material.dart';

class ClinicMetricCard extends StatelessWidget {
  const ClinicMetricCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.value,
    required this.deltaLabel,
    required this.positive,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String value;
  final String deltaLabel;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final deltaColor = positive ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final deltaIcon = positive ? Icons.north_east : Icons.south_east;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 24, color: iconColor),
              ),
              Row(
                children: [
                  Icon(deltaIcon, size: 16, color: deltaColor),
                  const SizedBox(width: 4),
                  Text(
                    deltaLabel,
                    style: TextStyle(
                      color: deltaColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4A5565),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF101828),
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
