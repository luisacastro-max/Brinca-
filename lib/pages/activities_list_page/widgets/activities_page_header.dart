import 'package:flutter/material.dart';

import 'activities_filter_tabs.dart';

class ActivitiesPageHeader extends StatelessWidget {
  const ActivitiesPageHeader({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final ActivitiesFilterType selectedFilter;
  final ValueChanged<ActivitiesFilterType> onFilterChanged;

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
}
