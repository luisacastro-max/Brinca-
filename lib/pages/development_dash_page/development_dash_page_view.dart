import 'package:app_twins/pages/development_dash_page/development_dash_page_service.dart';
import 'package:app_twins/pages/development_dash_page/development_dash_mocks.dart';
import 'package:app_twins/pages/development_dash_page/widgets/development_bar_chart_card.dart';
import 'package:app_twins/pages/development_dash_page/widgets/development_dash_filters.dart';
import 'package:app_twins/pages/development_dash_page/widgets/development_donut_chart_card.dart';
import 'package:app_twins/pages/development_dash_page/widgets/development_history_table_card.dart';
import 'package:app_twins/pages/development_dash_page/widgets/development_line_chart_card.dart';
import 'package:app_twins/pages/development_dash_page/widgets/development_metric_card.dart';
import 'package:flutter/material.dart';

class DevelopmentDashPageView extends StatefulWidget {
  const DevelopmentDashPageView({super.key});

  @override
  State<DevelopmentDashPageView> createState() =>
      _DevelopmentDashPageViewState();
}

class _DevelopmentDashPageViewState extends State<DevelopmentDashPageView> {
  final DevelopmentDashPageService _service = DevelopmentDashPageService();

  bool _isLoading = true;
  String? _errorMessage;

  List<DevelopmentChildOption> _children = const [];
  String? _selectedChildId;
  DevelopmentDashPeriod _selectedPeriod = DevelopmentDashPeriod.lastWeek;
  DevelopmentDashMockScenario? _selectedScenario =
      DevelopmentDashMockScenario.manyActivities;
  DevelopmentDashData? _data;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final children = await _service.loadChildren();
      if (children.isEmpty) {
        if (!mounted) return;
        setState(() {
          _children = const [];
          _selectedChildId = null;
          _data = null;
          _isLoading = false;
          _errorMessage = 'Nenhuma crianca cadastrada para exibir o dashboard.';
        });
        return;
      }

      final selectedId = _selectedChildId ?? children.first.id;
      final data = await _service.loadDashboard(
        childId: selectedId,
        period: _selectedPeriod,
        scenario:
            _selectedScenario ?? DevelopmentDashMockScenario.manyActivities,
      );

      if (!mounted) return;
      setState(() {
        _children = children;
        _selectedChildId = selectedId;
        _data = data;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Erro ao carregar dashboard: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshDashboard() async {
    final childId = _selectedChildId;
    if (childId == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _service.loadDashboard(
        childId: childId,
        period: _selectedPeriod,
        scenario:
            _selectedScenario ?? DevelopmentDashMockScenario.manyActivities,
      );
      if (!mounted) return;
      setState(() => _data = data);
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Erro ao atualizar dashboard: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _onChildChanged(String? childId) async {
    if (childId == null || childId == _selectedChildId) return;
    setState(() => _selectedChildId = childId);
    await _refreshDashboard();
  }

  Future<void> _onPeriodChanged(DevelopmentDashPeriod period) async {
    if (period == _selectedPeriod) return;
    setState(() => _selectedPeriod = period);
    await _refreshDashboard();
  }

  Future<void> _onScenarioChanged(DevelopmentDashMockScenario? scenario) async {
    if (scenario == null) return;
    if (scenario == _selectedScenario) return;
    setState(() => _selectedScenario = scenario);
    await _refreshDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _data == null) {
      return CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    }

    if (_errorMessage != null && _data == null) {
      return CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFFB42318)),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _loadInitial,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    final data = _data;
    if (data == null) {
      return CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          const SliverToBoxAdapter(child: SizedBox.shrink()),
        ],
      );
    }

    final consistencyColor = _consistencyColor(data.consistencyScore);

    return RefreshIndicator(
      onRefresh: _refreshDashboard,
      child: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dashboard de Desenvolvimento',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF101828),
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Acompanhamento completo e analítico',
                        style: TextStyle(fontSize: 14, color: Color(0xFF4A5565)),
                      ),
                      const SizedBox(height: 14),
                      DevelopmentDashFilters(
                        children: _children,
                        selectedChildId: _selectedChildId,
                        period: _selectedPeriod,
                        onChildChanged: _onChildChanged,
                        onPeriodChanged: _onPeriodChanged,
                      ),
                      const SizedBox(height: 10),
                      _buildScenarioSelector(),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                  ),
                  child: Column(
                    children: [
                      DevelopmentMetricCard(
                        icon: Icons.schedule,
                        iconBg: const Color(0xFFDBEAFE),
                        iconColor: const Color(0xFF2563EB),
                        title: 'Tempo Offline Total',
                        value: _formatMinutes(data.totalOfflineMinutes),
                        deltaPercent: data.totalDeltaPercent,
                      ),
                      const SizedBox(height: 10),
                      DevelopmentMetricCard(
                        icon: Icons.check_circle_outline,
                        iconBg: const Color(0xFFD1FAE5),
                        iconColor: const Color(0xFF10B981),
                        title: 'Atividades Concluidas',
                        value: '${data.completedActivities}',
                        deltaPercent: data.completedDeltaPercent,
                      ),
                      const SizedBox(height: 10),
                      DevelopmentMetricCard(
                        icon: Icons.trending_up,
                        iconBg: const Color(0xFFEDE9FE),
                        iconColor: const Color(0xFF9333EA),
                        title: 'Media Diaria',
                        value: '${data.dailyAverageHours.toStringAsFixed(1)}h',
                        deltaPercent: data.averageDeltaPercent,
                      ),
                      const SizedBox(height: 10),
                      DevelopmentMetricCard(
                        icon: Icons.gps_fixed,
                        iconBg: const Color(0xFFF2E1C9),
                        iconColor: const Color(0xFFFF4D00),
                        title: 'Score de Consistencia',
                        value: '${data.consistencyScore}%',
                        deltaPercent: 0,
                        highlightText: '${data.consistencyLabel} ',
                        highlightColor: consistencyColor,
                        trailingText: 'vs periodo anterior',
                      ),
                      const SizedBox(height: 10),
                      DevelopmentLineChartCard(values: data.offlineByWeek),
                      const SizedBox(height: 10),
                      DevelopmentBarChartCard(values: data.activitiesByWeek),
                      const SizedBox(height: 10),
                      DevelopmentDonutChartCard(distribution: data.distributionByArea),
                      const SizedBox(height: 10),
                      DevelopmentHistoryTableCard(items: data.historyItems),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: false,
      floating: false,
      snap: false,
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
    );
  }

  Widget _buildScenarioSelector() {
    final scenarios = _service.availableMockScenarios();
    final selected =
      _selectedScenario != null && scenarios.contains(_selectedScenario)
      ? _selectedScenario!
        : scenarios.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DevelopmentDashMockScenario>(
          value: selected,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF101828),
          ),
          items: scenarios
              .map(
                (scenario) => DropdownMenuItem<DevelopmentDashMockScenario>(
                  value: scenario,
                  child: Text(
                    'Cenario: ${scenario.label}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF101828),
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: _onScenarioChanged,
        ),
      ),
    );
  }

  String _formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final remaining = minutes % 60;
    return '${hours}h ${remaining.toString().padLeft(2, '0')}min';
  }

  Color _consistencyColor(int score) {
    if (score > 50) return const Color(0xFF0F9D58);
    if (score < 50) return const Color(0xFFE4572E);
    return const Color(0xFF6A7282);
  }
}
