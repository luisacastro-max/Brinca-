import 'package:app_twins/pages/development_dash_page/development_dash_page_service.dart';
import 'package:flutter/material.dart';

class DevelopmentDashFilters extends StatelessWidget {
  const DevelopmentDashFilters({
    super.key,
    required this.children,
    required this.selectedChildId,
    required this.period,
    required this.onChildChanged,
    required this.onPeriodChanged,
  });

  final List<DevelopmentChildOption> children;
  final String? selectedChildId;
  final DevelopmentDashPeriod period;
  final ValueChanged<String?> onChildChanged;
  final ValueChanged<DevelopmentDashPeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                          Text(
                            child.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF101828),
                            ),
                            overflow: TextOverflow.ellipsis,
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
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD0D5DD)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<DevelopmentDashPeriod>(
                    value: period,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF101828),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: DevelopmentDashPeriod.lastWeek,
                        child: Row(
                          children: [
                            Icon( 
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: Color(0xFF101828),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Ultima semana',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF101828),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: DevelopmentDashPeriod.lastTwoWeeks,
                        child: Row(
                          children: [
                            Icon( 
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: Color(0xFF101828),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Ultimas 2 semanas',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF101828),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: DevelopmentDashPeriod.lastMonth,
                        child: Row(
                          children: [
                            Icon( 
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: Color(0xFF101828),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Ultimo mês',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF101828),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) onPeriodChanged(value);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _squareAction(Icons.download_outlined),
            const SizedBox(width: 8),
            _squareAction(Icons.share_outlined, active: true),
          ],
        ),
      ],
    );
  }

  Widget _squareAction(IconData icon, {bool active = false}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF8B2CF5) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active ? const Color(0xFF8B2CF5) : const Color(0xFFD0D5DD),
        ),
      ),
      child: Icon(
        icon,
        size: 18,
        color: active ? Colors.white : const Color(0xFF344054),
      ),
    );
  }
}
