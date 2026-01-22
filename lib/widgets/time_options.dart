import 'package:app_twins/theme/theme_data_base.dart';
import 'package:flutter/material.dart';

class TimeOptions extends StatelessWidget {
  final int? selectedIndex;
  final Function(int) onSelectTime;

  const TimeOptions({
    super.key,
    required this.selectedIndex,
    required this.onSelectTime,
  });

  static const timeLabels = [
    "Menos de 10 minutos",
    "10-20 minutos",
    "20-30 minutos",
    "30-60 minutos",
    "Mais de 60 minutos",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tempo diário para atividades", style: containerTextStyle),
        const SizedBox(height: 15),
        Column(
          children: List.generate(
            timeLabels.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildSelectableButton(
                label: timeLabels[index],
                isSelected: selectedIndex == index,
                onTap: () => onSelectTime(index),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectableButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [
                    Color(0xFFFCA1AA),
                    Color(0xFFFFD54F),
                    Color(0xFFA8D8BB),
                    Color(0xFF7AA4E3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
