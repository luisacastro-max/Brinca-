import 'package:flutter/material.dart';

class ActivityDetailsHeader extends StatelessWidget {
  const ActivityDetailsHeader({
    super.key,
    required this.title,
    required this.description,
    required this.isFree,
  });

  final String title;
  final String description;
  final bool isFree;

  @override
  Widget build(BuildContext context) {
    final List<Color> bgColor = isFree ? [const Color(0xFFDCFCE7), const Color(0xFFDCFCE7)] : [const Color(0xFFFCE7F3), const Color(0xFFF3E8FF)];
    final fgColor = isFree ? const Color(0xFF008236) : const Color(0xFF8200DB);

    return Container(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 32,
                    height: 1.05,
                    color: Color(0xFF101828),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: bgColor,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  isFree ? 'Grátis' : 'Premium',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: fgColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF364153),
              fontSize: 16,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
