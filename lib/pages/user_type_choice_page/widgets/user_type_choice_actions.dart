import 'package:flutter/material.dart';

class UserTypeChoiceActions extends StatelessWidget {
  const UserTypeChoiceActions({
    super.key,
    required this.canContinue,
    required this.isLoading,
    required this.onContinue,
    required this.onLogin,
  });

  final bool canContinue;
  final bool isLoading;
  final VoidCallback onContinue;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: canContinue
                  ? const LinearGradient(
                      colors: [Color(0xFF58A6FF), Color(0xFF13B8D6)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: canContinue ? null : const Color(0xFFE5E7EB),
              boxShadow: canContinue
                  ? const [
                      BoxShadow(
                        color: Color(0x2213B8D6),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ]
                  : const [],
            ),
            child: TextButton(
              onPressed: canContinue && !isLoading ? onContinue : null,
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      'Continuar',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: canContinue ? Colors.white : const Color(0xFF9CA3AF),
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: isLoading ? null : onLogin,
          child: const Text(
            'Ja tenho conta',
            style: TextStyle(
              color: Color(0xFF1D73D5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
