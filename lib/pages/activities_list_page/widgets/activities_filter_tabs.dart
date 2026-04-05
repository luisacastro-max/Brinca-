import 'package:flutter/material.dart';

enum ActivitiesFilterType { all, saved }

class ActivitiesFilterTabs extends StatelessWidget {
  const ActivitiesFilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final ActivitiesFilterType selected;
  final ValueChanged<ActivitiesFilterType> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildButton(
            label: 'Salvos',
            icon: Icons.favorite_border,
            active: selected == ActivitiesFilterType.saved,
            onTap: () => onChanged(ActivitiesFilterType.saved),
          ),
          const SizedBox(width: 8),
          _buildButton(
            label: 'Todas',
            active: selected == ActivitiesFilterType.all,
            onTap: () => onChanged(ActivitiesFilterType.all),
          ),
          const SizedBox(width: 8),
          _buildButton(
            label: 'Desenvolvimento Emocional',
            active: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    IconData? icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Material(
      color: active ? const Color(0xFF00D3F3) : const Color(0xFFF3F4F6),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: active ? Colors.white : const Color(0xFF364153),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: active ? Colors.white : const Color(0xFF364153),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
