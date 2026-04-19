import 'package:app_twins/pages/development_dash_page/development_dash_page_service.dart';
import 'package:flutter/material.dart';

class DevelopmentHistoryTableCard extends StatefulWidget {
  const DevelopmentHistoryTableCard({
    super.key,
    required this.items,
  });

  final List<DevelopmentActivityHistoryItem> items;

  @override
  State<DevelopmentHistoryTableCard> createState() =>
      _DevelopmentHistoryTableCardState();
}

class _DevelopmentHistoryTableCardState extends State<DevelopmentHistoryTableCard> {
  bool _sortNewestFirst = true;

  List<DevelopmentActivityHistoryItem> get _sortedItems {
    final sorted = List<DevelopmentActivityHistoryItem>.from(widget.items);
    sorted.sort((a, b) {
      final compare = a.finishedAt.compareTo(b.finishedAt);
      return _sortNewestFirst ? -compare : compare;
    });
    return sorted;
  }

  void _toggleDateSort() {
    setState(() => _sortNewestFirst = !_sortNewestFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE3EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Historico Detalhado de Atividades',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF101828),
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.items.length} atividades registradas',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A5565),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _filterButton(),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _headerRow(),
          if (_sortedItems.isEmpty)
            const Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                'Nenhuma atividade encontrada no periodo selecionado.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            )
          else
            ..._buildRows(),
        ],
      ),
    );
  }

  Widget _filterButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.filter_alt_outlined, size: 16, color: Color(0xFF4B5563)),
          SizedBox(width: 6),
          Text(
            'Filtrar',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerRow() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE5E7EB)),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'ATIVIDADE',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A5565),
                letterSpacing: 1.5,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: _toggleDateSort,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _sortNewestFirst
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      size: 14,
                      color: const Color(0xFF4A5565),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'DATA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A5565),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'DURACAO',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A5565),
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRows() {
    final widgets = <Widget>[];
    final rows = _sortedItems;

    for (var i = 0; i < rows.length; i++) {
      final item = rows[i];
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                    height: 1.2,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  _formatDate(item.finishedAt),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${item.durationMinutes} min',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      if (i < rows.length - 1) {
        widgets.add(const Divider(height: 1, color: Color(0xFFE5E7EB)));
      }
    }

    return widgets;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
