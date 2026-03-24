import 'package:app_twins/theme/theme_data_base.dart';
import 'package:flutter/material.dart';

import 'time_options_vm.dart';

class TimeOptionsComponent extends StatelessWidget {
  final TimeOptionsViewModel viewModel;

  const TimeOptionsComponent._({super.key, required this.viewModel});

  static Widget instantiate({
    Key? key,
    required TimeOptionsViewModel viewModel,
  }) {
    return TimeOptionsComponent._(key: key, viewModel: viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tempo diário para atividades', style: containerTextStyle),
        const SizedBox(height: 15),
        Column(
          children: List.generate(
            viewModel.timeLabels.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildSelectableButton(
                label: viewModel.timeLabels[index],
                isSelected: viewModel.selectedIndex == index,
                onTap: () => viewModel.onSelectTime(index),
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
