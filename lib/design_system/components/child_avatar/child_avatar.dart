import 'package:app_twins/theme/theme_data_base.dart';
import 'package:flutter/material.dart';

import 'child_avatar_vm.dart';

class ChildAvatarComponent extends StatelessWidget {
  final ChildAvatarViewModel viewModel;

  const ChildAvatarComponent._({super.key, required this.viewModel});

  static Widget instantiate({
    Key? key,
    required ChildAvatarViewModel viewModel,
  }) {
    return ChildAvatarComponent._(key: key, viewModel: viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFCA1AA),
                  Color(0xFF7AA4E3),
                  Color(0xFFA8D8BB),
                ],
              ),
            ),
            child: const Icon(
              Icons.face_retouching_natural,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Criança ${viewModel.childIndex}',
            style: containerTextStyle.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
