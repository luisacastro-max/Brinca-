import 'package:app_twins/pages/recommend_page_page/recommend_page_page_service.dart';
import 'package:flutter/material.dart';

class RecommendActivityCard extends StatelessWidget {
  const RecommendActivityCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final RecommendActivityItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD8DEE6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontWeight: FontWeight.w700,
                fontSize: 34 / 1.6,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item.description,
              style: const TextStyle(
                color: Color(0xFF4B5563),
                fontSize: 17 / 1.2,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _NeutralPill(label: item.durationLabel),
                _NeutralPill(label: item.ageRangeLabel),
              ],
            ),
            const SizedBox(height: 10),
            if (item.developmentGoals.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: item.developmentGoals
                    .take(4)
                    .map((goal) => _GoalPill(label: goal))
                    .toList(),
              ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (item.isInclusive)
                  const _TagPill(
                    label: 'Inclusiva',
                    icon: Icons.verified_outlined,
                    background: Color(0xFFEDE9FE),
                    foreground: Color(0xFF4F46E5),
                  ),
                if (item.isLowCost)
                  const _TagPill(
                    label: 'Baixo custo',
                    icon: Icons.attach_money,
                    background: Color(0xFFDCFCE7),
                    foreground: Color(0xFF15803D),
                  ),
                if (item.isQuick)
                  const _TagPill(
                    label: 'Rapida',
                    icon: Icons.timer_outlined,
                    background: Color(0xFFFFEDD5),
                    foreground: Color(0xFFEA580C),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NeutralPill extends StatelessWidget {
  const _NeutralPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFECEFF3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF4B5563),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _GoalPill extends StatelessWidget {
  const _GoalPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF1D4ED8),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: foreground.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: foreground),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
