import 'package:app_twins/pages/progress_dashboard_page/progress_dashboard_page_service.dart';
import 'package:flutter/material.dart';

class ProgressDashboardAchievementChip extends StatelessWidget {
  const ProgressDashboardAchievementChip({
    super.key,
    required this.isDarkMode,
    required this.label,
    required this.accent,
  });

  final bool isDarkMode;
  final String label;
  final ProgressDashboardAccent accent;

  @override
  Widget build(BuildContext context) {
    final scheme = _chipScheme(accent);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode
            ? scheme.iconColor.withValues(alpha: 0.2)
            : scheme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(scheme.icon, size: 16, color: scheme.iconColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  _ChipScheme _chipScheme(ProgressDashboardAccent accent) {
    switch (accent) {
      case ProgressDashboardAccent.orange:
        return const _ChipScheme(
          icon: Icons.whatshot,
          backgroundColor: Color(0xFFFFF3E0),
          iconColor: Color(0xFFFF9800),
        );
      case ProgressDashboardAccent.green:
        return const _ChipScheme(
          icon: Icons.stars,
          backgroundColor: Color(0xFFE8F5E9),
          iconColor: Color(0xFF4CAF50),
        );
      case ProgressDashboardAccent.blue:
        return const _ChipScheme(
          icon: Icons.favorite,
          backgroundColor: Color(0xFFE3F2FD),
          iconColor: Color(0xFF2196F3),
        );
      case ProgressDashboardAccent.pink:
        return const _ChipScheme(
          icon: Icons.auto_awesome,
          backgroundColor: Color(0xFFFCE4EC),
          iconColor: Color(0xFFE91E63),
        );
      case ProgressDashboardAccent.purple:
        return const _ChipScheme(
          icon: Icons.emoji_events,
          backgroundColor: Color(0xFFEDE7F6),
          iconColor: Color(0xFF7E57C2),
        );
    }
  }
}

class _ChipScheme {
  const _ChipScheme({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
}
