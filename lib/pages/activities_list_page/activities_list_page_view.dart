import 'package:app_twins/pages/activities_list_page/activities_list_page_service.dart';
import 'package:app_twins/pages/activities_page/activities_page_router.dart';
import 'package:app_twins/pages/activities_list_page/widgets/activities_filter_tabs.dart';
import 'package:app_twins/pages/activities_list_page/widgets/activities_page_header.dart';
import 'package:app_twins/pages/activities_list_page/widgets/activity_list_item_card.dart';
import 'package:app_twins/pages/premium_plans_page/premium_plans_page_router.dart';
import 'package:flutter/material.dart';

class ActivitiesListPageView extends StatefulWidget {
  const ActivitiesListPageView({super.key});

  @override
  State<ActivitiesListPageView> createState() => _ActivitiesListPageViewState();
}

class _ActivitiesListPageViewState extends State<ActivitiesListPageView> {
  final ActivitiesListPageService _service = ActivitiesListPageService();
  static const int _pageSize = 10;

  bool _isLoading = true;
  String? _errorMessage;
  ActivitiesFilterType _filter = ActivitiesFilterType.all;
  int _currentPage = 0;

  List<ActivityListItem> _activities = const <ActivityListItem>[];
  Set<String> _savedIds = <String>{};
  bool _isCurrentUserPremium = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _service.loadPageData();
      if (!mounted) return;
      setState(() {
        _activities = data.activities;
        _savedIds = data.savedActivityIds;
        _isCurrentUserPremium = data.isCurrentUserPremium;
        _currentPage = 0;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Erro ao carregar atividades');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleOpenDetails(ActivityListItem item) async {
    final isPremiumActivity = !item.isFree;
    if (!isPremiumActivity || _isCurrentUserPremium) {
      await ActivitiesPageRouter.go(context, activityId: item.id);
      return;
    }

    final wantsPlans = await _showPremiumUpsellDialog();
    if (!mounted || wantsPlans != true) return;
    await PremiumPlansPageRouter.go(context);
  }

  Future<bool?> _showPremiumUpsellDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atividade Premium'),
        content: const Text(
          'Essa atividade esta disponivel apenas para usuarios premium. Deseja conhecer nossos planos?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Agora nao'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Ver planos'),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleSaved(String activityId) async {
    final updated = await _service.toggleSaved(activityId);
    if (!mounted) return;
    setState(() {
      _savedIds = updated;
      _clampCurrentPage();
    });
  }

  List<ActivityListItem> get _filteredActivities {
    if (_filter == ActivitiesFilterType.saved) {
      return _activities.where((item) => _savedIds.contains(item.id)).toList();
    }
    return _activities;
  }

  int get _totalPages {
    final total = _filteredActivities.length;
    if (total == 0) return 0;
    return (total / _pageSize).ceil();
  }

  List<ActivityListItem> get _pagedActivities {
    final items = _filteredActivities;
    if (items.isEmpty) return const <ActivityListItem>[];

    final start = _currentPage * _pageSize;
    final safeStart = start.clamp(0, items.length);
    final end = (safeStart + _pageSize).clamp(0, items.length);
    return items.sublist(safeStart, end);
  }

  void _clampCurrentPage() {
    final pages = _totalPages;
    if (pages == 0) {
      _currentPage = 0;
      return;
    }
    if (_currentPage >= pages) {
      _currentPage = pages - 1;
    }
    if (_currentPage < 0) {
      _currentPage = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Brinca+',
          style: TextStyle(
            color: Color(0xFF101828),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFE5E9F0), width: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3A4558)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          children: [
            ActivitiesPageHeader(
              selectedFilter: _filter,
              onFilterChanged: (value) => setState(() {
                _filter = value;
                _currentPage = 0;
                _clampCurrentPage();
              }),
            ),
            _buildListContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildListContent() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          children: [
            Text(
              _errorMessage!,
              style: const TextStyle(color: Color(0xFFB42318)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    final items = _pagedActivities;
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 30),
        child: Text(
          'Nenhuma atividade encontrada para o filtro selecionado.',
          style: TextStyle(color: Color(0xFF667085)),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            ActivityListItemCard(
              item: items[i],
              saved: _savedIds.contains(items[i].id),
              onToggleSaved: () => _toggleSaved(items[i].id),
              onOpenDetails: () => _handleOpenDetails(items[i]),
            ),
            if (i < items.length - 1) const SizedBox(height: 12),
          ],
          const SizedBox(height: 16),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    final pages = _totalPages;
    if (pages <= 1) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E7EC), width: 1.2),
      ),
      child: Row(
        children: [
          _paginationIconButton(
            icon: Icons.chevron_left,
            enabled: _currentPage > 0,
            onTap: () => setState(() {
              _currentPage -= 1;
              _clampCurrentPage();
            }),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Página ${_currentPage + 1} de $pages',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF344054),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _paginationIconButton(
            icon: Icons.chevron_right,
            enabled: _currentPage < pages - 1,
            onTap: () => setState(() {
              _currentPage += 1;
              _clampCurrentPage();
            }),
          ),
        ],
      ),
    );
  }

  Widget _paginationIconButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final backgroundColor = enabled
        ? const Color(0xFFF3F4F6)
        : const Color(0xFFE5E7EB);
    final iconColor = enabled
        ? const Color(0xFF364153)
        : const Color(0xFF98A2B3);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 20, color: iconColor),
        ),
      ),
    );
  }
}
