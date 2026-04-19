import 'package:app_twins/pages/activities_page/activities_page_service.dart';
import 'package:flutter/material.dart';

class ActivityPrimaryButton extends StatelessWidget {
  const ActivityPrimaryButton({
    super.key,
    required this.state,
    this.isLoading = false,
    required this.onPressed,
  });

  final ActivityProgressState state;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isCompleted = state == ActivityProgressState.completed;
    final isDisabled = isLoading || isCompleted;

    const borderRadius = BorderRadius.all(Radius.circular(14));

    final gradient = isCompleted
        ? const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFB8C2D1), Color(0xFF97A6B8)],
          )
        : const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFE85AAA), Color(0xFF1EB9E2)],
          );

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: gradient,
          boxShadow: const [
            BoxShadow(
              color: Color(0x3324A9CC),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: isDisabled ? null : onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_icon, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            _label,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData get _icon {
    switch (state) {
      case ActivityProgressState.notStarted:
        return Icons.play_arrow_rounded;
      case ActivityProgressState.started:
        return Icons.check_rounded;
      case ActivityProgressState.completed:
        return Icons.check_rounded;
    }
  }

  String get _label {
    switch (state) {
      case ActivityProgressState.notStarted:
        return 'Iniciar atividade';
      case ActivityProgressState.started:
        return 'Marcar como concluída';
      case ActivityProgressState.completed:
        return 'Atividade concluída';
    }
  }
}
