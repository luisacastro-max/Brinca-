import 'package:app_twins/pages/progress_dashboard_page/progress_dashboard_page_service.dart';
import 'package:flutter/material.dart';

class ProgressDashboardChildDropdown extends StatelessWidget {
  static const String addChildValue = '__add_child__';

  const ProgressDashboardChildDropdown({
    super.key,
    required this.children,
    required this.selectedChildId,
    required this.onChildChanged,
    required this.onAddChildPressed,
  });

  final List<ProgressDashboardChildOption> children;
  final String? selectedChildId;
  final ValueChanged<String?> onChildChanged;
  final VoidCallback onAddChildPressed;

  @override
  Widget build(BuildContext context) {
    final items =
        children
            .map(
              (child) => DropdownMenuItem<String>(
                value: child.id,
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF3E8FF),
                      ),
                      child: Center(
                        child: Text(
                          child.initial,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF9810FA),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        child.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF101828),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(${child.ageLabel})',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6A7282),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList()
          ..add(
            const DropdownMenuItem<String>(
              value: addChildValue,
              child: Row(
                children: [
                  Icon(
                    Icons.person_add_alt_1_outlined,
                    size: 20,
                    color: Color(0xFF344054),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Cadastrar criança',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF344054),
                    ),
                  ),
                ],
              ),
            ),
          );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD1D5DC)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: children.isEmpty ? null : selectedChildId,
          isExpanded: true,
          hint: const Text(
            'Selecionar criança',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6A7282),
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF344054)),
          items: items,
          onChanged: (value) {
            if (value == addChildValue) {
              onAddChildPressed();
              return;
            }

            onChildChanged(value);
          },
        ),
      ),
    );
  }
}
