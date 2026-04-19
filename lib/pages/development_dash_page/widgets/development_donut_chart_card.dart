import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DevelopmentDonutChartCard extends StatelessWidget {
  const DevelopmentDonutChartCard({super.key, required this.distribution});

  final Map<String, double> distribution;

  static const _colors = <String, Color>{
    'Motor': Color(0xFF8B5CF6),
    'Emocional': Color(0xFFEC4899),
    'Social': Color(0xFF10B981),
    'Cognitivo': Color(0xFF3B82F6),
    'Criativo': Color(0xFFF59E0B),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE3EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribuicao por Areas de\nDesenvolvimento',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF101828),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 54,
                sectionsSpace: 4,
                sections: [
                  for (final entry in distribution.entries)
                    PieChartSectionData(
                      value: entry.value,
                      color: _colors[entry.key] ?? const Color(0xFF9CA3AF),
                      title: '',
                      radius: 40,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Column(
            children: [
              for (final entry in distribution.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _colors[entry.key] ?? const Color(0xFF9CA3AF),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF475467),
                          ),
                        ),
                      ),
                      Text(
                        '${entry.value.round()}%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
