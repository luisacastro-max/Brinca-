import 'package:flutter/material.dart';

class HomeDrawerHeader extends StatelessWidget {
  const HomeDrawerHeader({
    super.key,
    required this.userName,
    required this.userInitial,
    required this.planLabel,
  });

  final String userName;
  final String userInitial;
  final String planLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFCE7F3), Color(0xFFCEFAFE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFBD7DE8), Color(0xFF4CB6EA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                userInitial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D2433),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  planLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF58657A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
