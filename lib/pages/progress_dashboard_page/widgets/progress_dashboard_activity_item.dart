import 'package:app_twins/pages/progress_dashboard_page/progress_dashboard_page_service.dart';
import 'package:flutter/material.dart';

class ProgressDashboardActivityItem extends StatelessWidget {
  const ProgressDashboardActivityItem({
    super.key,
    required this.isDarkMode,
    required this.title,
    required this.durationLabel,
    required this.categoryLabel,
    required this.accent,
  });

  final bool isDarkMode;
  final String title;
  final String durationLabel;
  final String categoryLabel;
  final ProgressDashboardAccent accent;

  @override
  Widget build(BuildContext context) {
    final scheme = _tileScheme(accent);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? scheme.iconColor.withValues(alpha: 0.2)
                  : scheme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(scheme.icon, color: scheme.iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      durationLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white60 : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        categoryLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white60 : Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _TileScheme _tileScheme(ProgressDashboardAccent accent) {
    switch (accent) {
      case ProgressDashboardAccent.purple:
        return const _TileScheme(
          icon: Icons.directions_run,
          backgroundColor: Color(0xFFE1BEE7),
          iconColor: Color(0xFF9C27B0),
        );
      case ProgressDashboardAccent.pink:
        return const _TileScheme(
          icon: Icons.palette,
          backgroundColor: Color(0xFFFCE4EC),
          iconColor: Color(0xFFE91E63),
        );
      case ProgressDashboardAccent.blue:
        return const _TileScheme(
          icon: Icons.favorite,
          backgroundColor: Color(0xFFE3F2FD),
          iconColor: Color(0xFF2196F3),
        );
      case ProgressDashboardAccent.green:
        return const _TileScheme(
          icon: Icons.groups,
          backgroundColor: Color(0xFFE8F5E9),
          iconColor: Color(0xFF4CAF50),
        );
      case ProgressDashboardAccent.orange:
        return const _TileScheme(
          icon: Icons.emoji_events,
          backgroundColor: Color(0xFFFFE0B2),
          iconColor: Color(0xFFFF9800),
        );
    }
  }
}

class _TileScheme {
  const _TileScheme({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
}
