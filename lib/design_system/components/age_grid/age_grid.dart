import 'package:app_twins/theme/theme_data_base.dart';
import 'package:flutter/material.dart';

import 'age_grid_vm.dart';

class AgeGridComponent extends StatelessWidget {
  final AgeGridViewModel viewModel;

  const AgeGridComponent._({super.key, required this.viewModel});

  static Widget instantiate({
    Key? key,
    required AgeGridViewModel viewModel,
  }) {
    return AgeGridComponent._(key: key, viewModel: viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Idade', style: containerTextStyle),
        const SizedBox(height: 15),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 113 / 60,
          children: List.generate(
            viewModel.ageLabels.length,
            (index) => _buildSelectableButton(
              label: viewModel.ageLabels[index],
              isSelected: viewModel.selectedIndex == index,
              onTap: () => viewModel.onSelectAge(index),
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
