import 'package:flutter/material.dart';

import '../design_system/components/child_avatar/child_avatar.dart';
import '../design_system/components/child_avatar/child_avatar_vm.dart';

class ChildAvatar extends StatelessWidget {
  final int childIndex;

  const ChildAvatar({super.key, required this.childIndex});

  @override
  Widget build(BuildContext context) {
    return ChildAvatarComponent.instantiate(
      viewModel: ChildAvatarViewModel(
        childIndex: childIndex,
      ),
    );
  }
}
