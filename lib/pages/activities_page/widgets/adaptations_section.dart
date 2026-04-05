import 'package:flutter/material.dart';

class AdaptationsSection extends StatelessWidget {
  const AdaptationsSection({
    super.key,
    required this.title,
    required this.items,
    required this.emptyMessage,
  });

  final String title;
  final List<String> items;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF101828),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              for (final item in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _AdaptationItem(raw: item),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdaptationItem extends StatelessWidget {
  const _AdaptationItem({required this.raw});

  final String raw;

  @override
  Widget build(BuildContext context) {
    final parts = raw.split(':');
    final title = parts.first.trim();
    final description = parts.length > 1 ? parts.sublist(1).join(':').trim() : '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Color(0xFFFF5BB0),
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0A0A0A),
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF364153),
                height: 1.55,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
