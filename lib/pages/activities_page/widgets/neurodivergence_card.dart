import 'package:flutter/material.dart';

class NeurodivergenceCard extends StatelessWidget {
  const NeurodivergenceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final iconColor = const Color(0xFF155DFC);
    final List<Color> background = [const Color.fromARGB(73, 252, 161, 170), const Color.fromARGB(118, 122, 204, 227)];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: background,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color.fromARGB(157, 122, 204, 227),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF7ACDE3)),
            ),
            child: Icon(Icons.auto_awesome_outlined, size: 24, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Validada para Neurodivergência',
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.0,
                    color: Color(0xFF0A0A0A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Esta atividade mostrou maior engajamento e respostas positivas entre crianças neurodivergentes, baseado em testes com clínicas de psicologia parceiras.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF364153),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
