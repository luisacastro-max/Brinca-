import 'package:flutter/material.dart';

class ProgressDashboardMotivationalCard extends StatelessWidget {
  const ProgressDashboardMotivationalCard({
    super.key,
    required this.isDarkMode,
  });

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [const Color(0xFF3D2E4F), const Color(0xFF2D2D44)]
              : [const Color(0xFFFCE4EC), const Color(0xFFE1BEE7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite,
              color: Color(0xFFE91E63),
              size: 28,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '"Pequenos momentos de brincadeira constroem grandes memorias."',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: isDarkMode ? Colors.white : Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Cada atividade que voce realiza com seu filho fortalece o vinculo entre voces e contribui para o desenvolvimento integral dele. Continue criando esses momentos especiais juntos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDarkMode ? Colors.white70 : Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('✨', style: TextStyle(fontSize: 24)),
              SizedBox(width: 8),
              Text('💚', style: TextStyle(fontSize: 24)),
              SizedBox(width: 8),
              Text('⭐', style: TextStyle(fontSize: 24)),
            ],
          ),
        ],
      ),
    );
  }
}
