import 'package:flutter/material.dart';

class HomeWeekSummaryCard extends StatelessWidget {
  const HomeWeekSummaryCard({
    super.key,
    required this.completedActivitiesThisWeek,
  });

  final int completedActivitiesThisWeek;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFFF9EFF2), Color(0xFFE6F6FC)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎉 Parabéns!',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Você completou $completedActivitiesThisWeek atividades offline\nesta semana. Continue assim!',
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              height: 1.4,
              color: Color(0xFF364153),
            ),
          ),
        ],
      ),
    );
  }
}
