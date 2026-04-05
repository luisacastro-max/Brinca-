import 'package:flutter/material.dart';

class StepsSection extends StatelessWidget {
  const StepsSection({super.key, required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.list_alt, size: 20, color: Color(0xFF2563EB)),
              SizedBox(width: 10),
              Text(
                'Passo a Passo',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (steps.isEmpty)
            const Text(
              'Nao informado no backend.',
              style: TextStyle(fontSize: 14, color: Color(0xFF667085)),
            )
          else
            Column(
              children: [for (var i = 0; i < steps.length; i++) _buildStep(i)],
            ),
        ],
      ),
    );
  }

  Widget _buildStep(int index) {
    final item = steps[index];
    final title = item.split('.').first;
    final description = item.split('.').skip(1).join('.').trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFDCEAFE),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1E2939),
                    height: 1.5,
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '💡 $description',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1447E6),
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
