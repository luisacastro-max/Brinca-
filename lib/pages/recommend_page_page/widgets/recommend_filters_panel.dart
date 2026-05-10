import 'package:flutter/material.dart';

class RecommendFiltersPanel extends StatelessWidget {
  const RecommendFiltersPanel({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.selectedObjectives,
    required this.onObjectivesChanged,
    required this.onClearObjectives,
    required this.availableObjectives,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final Set<String> selectedObjectives;
  final ValueChanged<Set<String>> onObjectivesChanged;
  final VoidCallback onClearObjectives;
  final List<String> availableObjectives;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Buscar atividade...',
              prefixIcon: const Icon(Icons.search, size: 18),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
              filled: true,
              fillColor: const Color(0xFFFFFFFF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFD0D5DD)),
            ),
            child: PopupMenuButton<String>(
              tooltip: 'Filtrar por objetivos',
              offset: const Offset(0, 44),
              splashRadius: 20,
              color: Colors.white,
              surfaceTintColor: Colors.white,
              shadowColor: const Color(0x1A111827),
              elevation: 10,
              menuPadding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                final updated = Set<String>.from(selectedObjectives);

                if (value == '__clear__') {
                  updated.clear();
                  onObjectivesChanged(updated);
                  return;
                }

                if (updated.contains(value)) {
                  updated.remove(value);
                } else {
                  updated.add(value);
                }

                onObjectivesChanged(updated);
              },
              itemBuilder: (context) {
                return [
                  for (final objective in availableObjectives)
                    PopupMenuItem<String>(
                      value: objective,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: selectedObjectives.contains(objective)
                              ? const Color(0xFFE8F0FE)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectedObjectives.contains(objective)
                                ? const Color(0xFFBFDBFE)
                                : const Color(0xFFE5E7EB),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                objective,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: selectedObjectives.contains(objective)
                                      ? const Color(0xFF1D4ED8)
                                      : const Color(0xFF111827),
                                ),
                              ),
                            ),
                            if (selectedObjectives.contains(objective))
                              const Icon(
                                Icons.check,
                                size: 18,
                                color: Color(0xFF1D4ED8),
                              ),
                          ],
                        ),
                      ),
                    ),
                ];
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedObjectives.isEmpty
                            ? 'Todos os objetivos'
                            : _summaryLabel(selectedObjectives.length),
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (selectedObjectives.isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectedObjectives
                        .map((value) => _SelectedObjectivePill(label: value))
                        .toList(),
                  ),
                ),
                TextButton(
                  onPressed: onClearObjectives,
                  child: const Text('Limpar filtros'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _summaryLabel(int selectedCount) {
    if (selectedCount == 1) return '1 objetivo selecionado';
    return '$selectedCount objetivos selecionados';
  }
}

class _SelectedObjectivePill extends StatelessWidget {
  const _SelectedObjectivePill({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF1D4ED8),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}