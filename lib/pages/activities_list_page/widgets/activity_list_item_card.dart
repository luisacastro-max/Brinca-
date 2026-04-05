import 'package:app_twins/pages/activities_list_page/activities_list_page_service.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ActivityListItemCard extends StatelessWidget {
  const ActivityListItemCard({
    super.key,
    required this.item,
    required this.saved,
    required this.onToggleSaved,
    required this.onOpenDetails,
  });

  final ActivityListItem item;
  final bool saved;
  final VoidCallback onToggleSaved;
  final VoidCallback onOpenDetails;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onOpenDetails,
        child: Ink(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE4E7EC), width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F101828),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828),
                          height: 1.15,
                        ),
                      ),
                      _priceBadge(),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: onToggleSaved,
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          saved ? Icons.favorite : Icons.favorite_border,
                          color: saved
                              ? const Color(0xFFE11D48)
                              : const Color(0xFF98A2B3),
                          size: 22,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF98A2B3),
                        size: 32,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A5565),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                spacing: 8,
                children: [
                  _metaItem(Icons.schedule_outlined, item.durationLabel),
                  _metaItem(
                    Icons.family_restroom_outlined,
                    _formatAgeRange(item.ageRange),
                  ),
                  _chip(item.difficulty),
                  if (item.isNeurodivergenceValid) ...[
                    const SizedBox(height: 10),
                    _neuroChip(),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceBadge() {
    final List<Color> bgColor = item.isFree ? [const Color(0xFFDCFCE7)] : [const Color(0xFFFCE7F3), const Color(0xFFF3E8FF)];
    final fgColor = item.isFree ? const Color(0xFF008236) : const Color(0xFF8200DB);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: bgColor,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        item.isFree ? 'Gratis' : 'Premium',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fgColor,
        ),
      ),
    );
  }

  Widget _metaItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF98A2B3)),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6A7282),
          ),
        ),
      ],
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF364153),
        ),
      ),
    );
  }

  Widget _neuroChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.psychology_outlined, size: 14, color: Color(0xFF432DD7)),
          SizedBox(width: 6),
          Text(
            'Validada para\nneurodivergência',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF432DD7),
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAgeRange(String value) {
    if (value.contains('-')) {
      final parts = value.split('-');
      if (parts.length == 2) {
        return '${parts[0]}-${parts[1]} anos';
      }
    }

    if (value.trim().isEmpty) {
      return 'Nao informado';
    }

    return value;
  }
}
