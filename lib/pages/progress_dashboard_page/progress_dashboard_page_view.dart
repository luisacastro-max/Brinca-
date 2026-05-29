import 'package:app_twins/pages/children_selection_page/children_selection_page_router.dart';
import 'package:app_twins/pages/premium_plans_page/premium_plans_page_router.dart';
import 'package:app_twins/pages/progress_dashboard_page/progress_dashboard_page_service.dart';
import 'package:app_twins/pages/progress_dashboard_page/widgets/progress_dashboard_child_dropdown.dart';
import 'package:app_twins/pages/progress_dashboard_page/widgets/progress_dashboard_achievement_chip.dart';
import 'package:app_twins/pages/progress_dashboard_page/widgets/progress_dashboard_activity_item.dart';
import 'package:app_twins/pages/progress_dashboard_page/widgets/progress_dashboard_area_chip.dart';
import 'package:app_twins/pages/progress_dashboard_page/widgets/progress_dashboard_motivational_card.dart';
import 'package:app_twins/pages/progress_dashboard_page/widgets/progress_dashboard_stat_card.dart';
import 'package:app_twins/pages/progress_dashboard_page/widgets/progress_dashboard_summary_card.dart';
import 'package:app_twins/services/service.dart';
import 'package:app_twins/widgets/free_plan_limit_dialog.dart';
import 'package:flutter/material.dart';

class ProgressDashboardPageView extends StatefulWidget {
  const ProgressDashboardPageView({super.key});

  @override
  State<ProgressDashboardPageView> createState() =>
      _ProgressDashboardPageViewState();
}

class _ProgressDashboardPageViewState extends State<ProgressDashboardPageView> {
  final ProgressDashboardPageService _service = ProgressDashboardPageService();

  bool _isDarkMode = false;
  bool _isLoading = true;
  String? _errorMessage;
  List<ProgressDashboardChildOption> _children =
      const <ProgressDashboardChildOption>[];
  String? _selectedChildId;
  ProgressDashboardViewData? _data;

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
      final pageData = await _service.loadPageData(
        selectedChildId: _selectedChildId,
      );
      if (!mounted) return;
      setState(() {
        _children = pageData.children;
        _selectedChildId = pageData.selectedChildId;
        _data = pageData.dashboard;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Erro ao carregar progresso semanal.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleChildChanged(String? childId) async {
    if (childId == null || childId == _selectedChildId) return;

    setState(() => _selectedChildId = childId);
    await _loadData();
  }

  Future<void> _handleAddChildPressed() async {
    final currentUser = await ServiceSdk.instance.auth.getCurrentUser();
    if (!mounted) return;

    final isCurrentUserPremium = currentUser?.isPremium ?? false;
    final mustBlockByFreePlan = !isCurrentUserPremium && _children.isNotEmpty;

    if (mustBlockByFreePlan) {
      final action = await showFreePlanLimitDialog(context);
      if (!mounted) return;

      if (action == FreePlanDialogAction.openPlans) {
        await PremiumPlansPageRouter.go(context);
      }
      return;
    }

    await ChildrenSelectionPageRouter.go(context);
    if (!mounted) return;
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode
          ? const Color(0xFF1A1A2E)
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onTap: () {
            setState(() {
              _isDarkMode = !_isDarkMode;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isDarkMode
                    ? const Color(0xFF3D3D5C)
                    : Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  size: 16,
                  color: _isDarkMode ? Colors.amber : Colors.orange,
                ),
                const SizedBox(width: 6),
                Text(
                  'Modo Escuro',
                  style: TextStyle(
                    fontSize: 14,
                    color: _isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: _loadData,
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    final data = _data;
    if (data == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressDashboardChildDropdown(
            children: _children,
            selectedChildId: _selectedChildId,
            onChildChanged: _handleChildChanged,
            onAddChildPressed: _handleAddChildPressed,
          ),
          const SizedBox(height: 20),
          ProgressDashboardSummaryCard(
            isDarkMode: _isDarkMode,
            message: data.congratulationMessage,
            supportMessage: data.supportMessage,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ProgressDashboardStatCard(
                  isDarkMode: _isDarkMode,
                  icon: Icons.access_time,
                  label: 'Tempo offline',
                  value: data.totalOfflineShortLabel,
                  backgroundColor: const Color(0xFFE3F2FD),
                  iconColor: const Color(0xFF2196F3),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ProgressDashboardStatCard(
                  isDarkMode: _isDarkMode,
                  icon: Icons.check_circle,
                  label: 'Atividades',
                  value: data.completedActivitiesThisWeek.toString(),
                  backgroundColor: const Color(0xFFE8F5E9),
                  iconColor: const Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildWeeklyAchievements(data),
          const SizedBox(height: 24),
          _buildStimulatedAreas(data),
          const SizedBox(height: 24),
          _buildWeeklyActivities(data),
          const SizedBox(height: 24),
          ProgressDashboardMotivationalCard(isDarkMode: _isDarkMode),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWeeklyAchievements(ProgressDashboardViewData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: Color(0xFFFFA726),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Conquistas da Semana',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: _isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (data.achievements.isEmpty)
            Text(
              'As conquistas aparecem quando novas atividades sao concluidas.',
              style: TextStyle(
                fontSize: 13,
                color: _isDarkMode ? Colors.white60 : Colors.grey[600],
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: data.achievements
                  .map(
                    (achievement) => ProgressDashboardAchievementChip(
                      isDarkMode: _isDarkMode,
                      label: achievement.label,
                      accent: achievement.accent,
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildStimulatedAreas(ProgressDashboardViewData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Areas Estimuladas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        if (data.areas.isEmpty)
          Text(
            'As areas estimuladas aparecerao aqui quando houver atividades concluidas.',
            style: TextStyle(
              fontSize: 13,
              color: _isDarkMode ? Colors.white60 : Colors.grey[600],
            ),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: data.areas
                .map(
                  (area) => ProgressDashboardAreaChip(
                    isDarkMode: _isDarkMode,
                    label: area.label,
                    accent: area.accent,
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildWeeklyActivities(ProgressDashboardViewData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Atividades da Semana',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        if (data.activities.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _isDarkMode ? const Color(0xFF2D2D44) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              data.hasChild
                  ? 'Nenhuma atividade concluida nesta semana ainda.'
                  : 'Nenhuma crianca cadastrada para mostrar atividades.',
              style: TextStyle(
                fontSize: 13,
                color: _isDarkMode ? Colors.white60 : Colors.grey[600],
              ),
            ),
          )
        else
          ...data.activities.map(
            (activity) => ProgressDashboardActivityItem(
              isDarkMode: _isDarkMode,
              title: activity.title,
              durationLabel: activity.durationLabel,
              categoryLabel: activity.categoryLabel,
              accent: activity.accent,
            ),
          ),
      ],
    );
  }
}
