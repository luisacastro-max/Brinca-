import 'package:flutter/material.dart';

class ProgressDashboardSummaryCard extends StatelessWidget {
  const ProgressDashboardSummaryCard({
    super.key,
    required this.isDarkMode,
    required this.message,
    required this.supportMessage,
  });

  final bool isDarkMode;
  final String message;
  final String supportMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE6E6FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Color(0xFF7B68EE),
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Parabens!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            supportMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDarkMode ? Colors.white60 : Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
