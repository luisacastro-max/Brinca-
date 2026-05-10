import 'package:flutter/material.dart';

class PatientManagementFilters extends StatelessWidget {
  const PatientManagementFilters({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.selectedAgeRange,
    required this.onAgeRangeChanged,
    required this.selectedEngagement,
    required this.onEngagementChanged,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final String selectedAgeRange;
  final ValueChanged<String> onAgeRangeChanged;
  final String selectedEngagement;
  final ValueChanged<String> onEngagementChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Buscar por nome...',
              hintStyle: const TextStyle(
                color: Color.fromARGB(127, 10, 10, 10),
                fontSize: 16,
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 24,
                color: Color(0xFF99A1AF)
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
              filled: true,
              fillColor: const Color(0xFFFFFFFF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFD1D5DC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _FilterDropdown(
                  value: selectedAgeRange,
                  options: const [
                    _FilterOption('all', 'Todas as idades'),
                    _FilterOption('0-3', '0-3 anos'),
                    _FilterOption('4-6', '4-6 anos'),
                    _FilterOption('7-9', '7-9 anos'),
                    _FilterOption('10-12', '10-12 anos'),
                  ],
                  onChanged: onAgeRangeChanged,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FilterDropdown(
                  value: selectedEngagement,
                  options: const [
                    _FilterOption('all', 'Todos os engajamentos'),
                    _FilterOption('high', 'Alto'),
                    _FilterOption('medium', 'Medio'),
                    _FilterOption('low', 'Baixo'),
                  ],
                  onChanged: onEngagementChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<_FilterOption> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD1D5DC)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          style: const TextStyle(
            color: Color(0xFF000000),
            fontSize: 14,
          ),
          items: options
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option.value,
                  child: Text(option.label),
                ),
              )
              .toList(),
          onChanged: (newValue) {
            if (newValue == null) return;
            onChanged(newValue);
          },
        ),
      ),
    );
  }
}

class _FilterOption {
  const _FilterOption(this.value, this.label);

  final String value;
  final String label;
}
