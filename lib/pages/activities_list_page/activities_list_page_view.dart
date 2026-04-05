import 'package:app_twins/pages/activities_list_page/activities_list_page_service.dart';
import 'package:app_twins/pages/activities_page/activities_page_router.dart';
import 'package:app_twins/pages/activities_list_page/widgets/activities_filter_tabs.dart';
import 'package:app_twins/pages/activities_list_page/widgets/activities_page_header.dart';
import 'package:app_twins/pages/activities_list_page/widgets/activity_list_item_card.dart';
import 'package:flutter/material.dart';

class ActivitiesListPageView extends StatefulWidget {
  const ActivitiesListPageView({super.key});

  @override
  State<ActivitiesListPageView> createState() => _ActivitiesListPageViewState();
}

class _ActivitiesListPageViewState extends State<ActivitiesListPageView> {
  final ActivitiesListPageService _service = ActivitiesListPageService();

  bool _isLoading = true;
  String? _errorMessage;
  ActivitiesFilterType _filter = ActivitiesFilterType.all;

  List<ActivityListItem> _activities = const <ActivityListItem>[];
  Set<String> _savedIds = <String>{};

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
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Erro ao carregar atividades');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleSaved(String activityId) async {
    final updated = await _service.toggleSaved(activityId);
    if (!mounted) return;
    setState(() => _savedIds = updated);
  }

  List<ActivityListItem> get _filteredActivities {
    if (_filter == ActivitiesFilterType.saved) {
      return _activities.where((item) => _savedIds.contains(item.id)).toList();
    }
    return _activities;
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
              onFilterChanged: (value) => setState(() => _filter = value),
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

    final items = _filteredActivities;
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
              onOpenDetails: () =>
                  ActivitiesPageRouter.go(context, activityId: items[i].id),
            ),
            if (i < items.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
