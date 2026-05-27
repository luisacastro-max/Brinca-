import 'package:flutter/material.dart';

import 'package:app_twins/pages/activities_list_page/activities_list_page_service.dart';

import 'activities_filter_tabs.dart';

class ActivitiesPageHeader extends StatelessWidget {
  const ActivitiesPageHeader({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.children,
    required this.selectedChildId,
    required this.onChildChanged,
  });

  final ActivitiesFilterType selectedFilter;
  final ValueChanged<ActivitiesFilterType> onFilterChanged;
  final List<ActivitiesChildOption> children;
  final String? selectedChildId;
  final ValueChanged<String?> onChildChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFF000000), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Atividades para Brincar Offline',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF101828),
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Promova o desenvolvimento saudável das crianças com brincadeiras que estimulam criatividade, movimento e imaginação — tudo sem telas!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF4A5565),
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 16),
                _buildChildDropdown(),
                SizedBox(height: 12),
                ActivitiesFilterTabs(
                  selected: selectedFilter,
                  onChanged: onFilterChanged,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            margin: const EdgeInsets.only(top: 38),
            child: const Icon(
              Icons.insert_chart_outlined,
              color: Color(0xFF667085),
              size: 48,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildDropdown() {
    if (children.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD1D5DC)),
        ),
        child: const Text(
          'Nenhuma criança cadastrada',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6A7282),
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD1D5DC)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedChildId,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF344054),
          ),
          items: children
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
              .toList(),
          onChanged: onChildChanged,
        ),
      ),
    );
  }
}
