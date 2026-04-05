import 'package:app_twins/pages/activities_page/activities_page_service.dart';
import 'package:flutter/material.dart';

class ActivityPrimaryButton extends StatelessWidget {
  const ActivityPrimaryButton({
    super.key,
    required this.state,
    required this.onPressed,
  });

  final ActivityProgressState state;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isCompleted = state == ActivityProgressState.completed;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isCompleted ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: isCompleted
              ? const Color(0xFF94A3B8)
              : const Color(0xFFEC4899),
          foregroundColor: Colors.white,
        ),
        child: Text(
          _label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  String get _label {
    switch (state) {
      case ActivityProgressState.notStarted:
        return 'Iniciar atividade';
      case ActivityProgressState.started:
        return 'Marcar como concluida';
      case ActivityProgressState.completed:
        return 'Atividade concluida';
    }
  }
}
