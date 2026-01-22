import 'package:app_twins/theme/theme_data_base.dart';
import 'package:flutter/material.dart';

class AgeGrid extends StatelessWidget {
  final int? selectedIndex;
  final Function(int) onSelectAge;

  const AgeGrid({
    super.key,
    required this.selectedIndex,
    required this.onSelectAge,
  });

  static const ageLabels = [
    "0-1 ano",
    "1-2 anos",
    "2-3 anos",
    "3-4 anos",
    "4-5 anos",
    "5-6 anos",
    "6-7 anos",
    "7-8 anos",
    "8-9 anos",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Idade", style: containerTextStyle),
        const SizedBox(height: 15),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 113 / 60,
          children: List.generate(
            ageLabels.length,
            (index) => _buildSelectableButton(
              label: ageLabels[index],
              isSelected: selectedIndex == index,
              onTap: () => onSelectAge(index),
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
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [
                    Color(0xFFFCA1AA),
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
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
