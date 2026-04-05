import 'package:flutter/material.dart';

class ActivityInfoGrid extends StatelessWidget {
  const ActivityInfoGrid({
    super.key,
    required this.duration,
    required this.age,
    required this.area,
    required this.difficulty,
  });

  final String duration;
  final String age;
  final String area;
  final String difficulty;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withClampedTextScaling(
      minScaleFactor: 1.0,
      maxScaleFactor: 1.0,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.2,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _tile(
            Icons.schedule_outlined,
            const Color(0xFF3B82F6),
            'Duração',
            duration,
          ),
          _tile(
            Icons.family_restroom_outlined,
            const Color(0xFF00A63E),
            'Idade',
            age,
          ),
          _tile(
            Icons.auto_awesome_outlined,
            const Color(0xFF9810FA),
            'Área',
            area,
          ),
          _tile(
            Icons.adjust_outlined,
            const Color(0xFFF54900),
            'Dificuldade',
            difficulty,
          ),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, Color iconColor, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A5565),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0A0A0A),
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
