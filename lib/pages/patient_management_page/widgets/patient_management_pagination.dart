import 'package:flutter/material.dart';

class PatientManagementPagination extends StatelessWidget {
  const PatientManagementPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPrev,
    required this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: currentPage > 1 ? onPrev : null,
          icon: const Icon(Icons.chevron_left, size: 18),
          label: const Text('Anterior'),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Pagina $currentPage de $totalPages',
              style: const TextStyle(
                color: Color(0xFF4B5563),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: currentPage < totalPages ? onNext : null,
          icon: const Icon(Icons.chevron_right, size: 18),
          label: const Text('Proxima'),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
        ),
      ],
    );
  }
}
