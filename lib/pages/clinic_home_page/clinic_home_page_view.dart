import 'package:app_twins/pages/activities_list_page/activities_list_page_router.dart';
import 'package:app_twins/pages/children_list_page/children_list_page_router.dart';
import 'package:app_twins/pages/clinic_home_page/clinic_home_page_service.dart';
import 'package:app_twins/pages/clinic_home_page/widgets/clinic_attention_item_tile.dart';
import 'package:app_twins/pages/clinic_home_page/widgets/clinic_metric_card.dart';
import 'package:app_twins/pages/clinic_home_page/widgets/clinic_quick_action_card.dart';
import 'package:app_twins/pages/clinic_home_page/widgets/clinic_recent_activity_item_tile.dart';
import 'package:app_twins/pages/home_page/widgets/home_drawer_header.dart';
import 'package:app_twins/pages/home_page/widgets/home_drawer_item.dart';
import 'package:app_twins/pages/login_page/login_page_router.dart';
import 'package:app_twins/pages/patient_management_page/patient_management_page_router.dart';
import 'package:app_twins/services/service.dart';
import 'package:flutter/material.dart';

class ClinicHomePageView extends StatefulWidget {
  const ClinicHomePageView({super.key});

  @override
  State<ClinicHomePageView> createState() => _ClinicHomePageViewState();
}

class _ClinicHomePageViewState extends State<ClinicHomePageView> {
  final ClinicHomePageService _service = ClinicHomePageService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;
  String? _errorMessage;
  ClinicHomePageData? _data;
  BackendUser? _currentUser;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _service.loadData();
      final currentUser = await ServiceSdk.instance.auth.getCurrentUser();
      if (!mounted) return;
      setState(() {
        _data = data;
        _currentUser = currentUser;
      });
    } on ServiceException catch (e) {
      if (!mounted) return;

      if (e.statusCode == 401 || e.statusCode == 403) {
        await Navigator.of(context).pushAndRemoveUntil(
          LoginPageRouter.route(),
          (_) => false,
        );
        return;
      }

      setState(() => _errorMessage = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Erro ao carregar painel da clinica.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await ServiceSdk.instance.auth.logout();
    if (!mounted) return;
    await Navigator.of(
      context,
    ).pushAndRemoveUntil(LoginPageRouter.route(), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFE5E9F0), width: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF3A4558), size: 24),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          'Brinca+',
          style: TextStyle(
            color: Color(0xFF101828),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _data == null) {
      return ListView(
        children: [
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFB42318)),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _load,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final data = _data;
    if (data == null) {
      return ListView(children: const [SizedBox(height: 1)]);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      children: [
        const Text(
          'Painel da Clinica',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF101828),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Visao geral do progresso dos pacientes',
          style: TextStyle(
            color: Color(0xFF4A5565),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 32),
        ClinicMetricCard(
          icon: Icons.group_outlined,
          iconColor: const Color(0xFF2563EB),
          iconBackground: const Color(0xFFDBEAFE),
          title: 'Pacientes Ativos',
          value: '${data.metric.activePatients}',
          deltaLabel: _formatDeltaLabel(data.metric.activePatientsDelta),
          positive: data.metric.activePatientsDelta >= 0,
        ),
        const SizedBox(height: 16),
        ClinicMetricCard(
          icon: Icons.show_chart,
          iconColor: const Color(0xFF16A34A),
          iconBackground: const Color(0xFFDCFCE7),
          title: 'Atividades desta Semana',
          value: '${data.metric.completedThisWeek}',
          deltaLabel: _formatDeltaLabel(data.metric.completedPerChildDelta),
          positive: data.metric.completedPerChildDelta >= 0,
        ),
        const SizedBox(height: 16),
        ClinicMetricCard(
          icon: Icons.schedule_outlined,
          iconColor: const Color(0xFF9333EA),
          iconBackground: const Color(0xFFEDE9FE),
          title: 'Tempo Offline Medio',
          value: '${data.metric.averageOfflineHours.toStringAsFixed(1)}h',
          deltaLabel: _formatDeltaLabel(data.metric.averageOfflineHoursDelta),
          positive: data.metric.averageOfflineHoursDelta >= 0,
        ),
        const SizedBox(height: 16),
        ClinicMetricCard(
          icon: Icons.trending_up,
          iconColor: const Color(0xFFF97316),
          iconBackground: const Color(0xFFFFEDD5),
          title: 'Taxa de Engajamento',
          value: '${data.metric.engagementRate}%',
          deltaLabel: _formatDeltaLabel(data.metric.engagementRateDelta),
          positive: data.metric.engagementRateDelta >= 0,
        ),
        const SizedBox(height: 32),
        _buildSectionContainer(
          title: 'Atividades Recentes',
          actionLabel: 'Ver todos',
          child: data.recentActivities.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text(
                    'Nenhuma atividade concluida ainda.',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                )
              : Column(
                  spacing: 8,
                  children: [
                    for (var i = 0; i < data.recentActivities.length; i++) ...[
                      ClinicRecentActivityItemTile(
                        initials: _initialsFromName(
                          data.recentActivities[i].childName,
                        ),
                        childName: data.recentActivities[i].childName,
                        childAgeLabel: '(${data.recentActivities[i].childAgeLabel})',
                        activityTitle: data.recentActivities[i].activityTitle,
                        timeLabel: data.recentActivities[i].completedLabel,
                      ),
                      if (i < data.recentActivities.length - 1)
                        const SizedBox(height: 10),
                    ],
                  ],
                ),
        ),
        const SizedBox(height: 32),
        _buildSectionContainer(
          title: 'Atencao Necessaria',
          child: data.attentionItems.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Nenhum alerta no momento.',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                )
              : Column(
                  children: [
                    for (var i = 0; i < data.attentionItems.length; i++) ...[
                      ClinicAttentionItemTile(
                        childName: data.attentionItems[i].childName,
                        ageLabel: data.attentionItems[i].ageLabel,
                        message: data.attentionItems[i].message,
                        priority: data.attentionItems[i].priority,
                      ),
                      if (i < data.attentionItems.length - 1)
                        const SizedBox(height: 16),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF374151),
                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text('Ver todos os alertas')
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 32),
        ClinicQuickActionCard(
          title: 'Gerenciar Pacientes',
          subtitle: 'Ver lista completa e detalhes',
          onTap: () => PatientManagementPageRouter.go(context),
        ),
        const SizedBox(height: 16),
        ClinicQuickActionCard(
          title: 'Recomendar Atividades',
          subtitle: 'Enviar sugestoes personalizadas',
          onTap: () => ActivitiesListPageRouter.go(context),
        ),
        const SizedBox(height: 16),
        ClinicQuickActionCard(
          title: 'Gerar Relatorios',
          subtitle: 'Exportar dados e analises',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSectionContainer({
    required String title,
    String? actionLabel,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF101828),
                  ),
                ),
              ),
              if (actionLabel != null)
                TextButton(
                  onPressed: () => ActivitiesListPageRouter.go(context),
                  child: Text(
                    actionLabel,
                    style: const TextStyle(
                      color: Color(0xFF155DFC),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    final user = _currentUser;
    final userName = (user?.name.trim().isNotEmpty ?? false)
        ? user!.name
        : 'Usuario';
    final userInitial = userName.substring(0, 1).toUpperCase();
    const planLabel = 'Perfil Clinica';

    return SizedBox(
      child: Drawer(
        backgroundColor: const Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFCE7F3), Color(0xFFCEFAFE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 10, 10),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Brinca+',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E2738),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xFF3B4659),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              HomeDrawerHeader(
                userName: userName,
                userInitial: userInitial,
                planLabel: planLabel,
              ),
              const SizedBox(height: 10),
              HomeDrawerItem(
                icon: Icons.home_outlined,
                label: 'Inicio',
                selected: true,
                onTap: () => Navigator.of(context).pop(),
              ),
              HomeDrawerItem(
                icon: Icons.people_alt_outlined,
                label: 'Gerenciar Pacientes',
                onTap: () {
                  Navigator.of(context).pop();
                  PatientManagementPageRouter.go(context);
                },
              ),
              HomeDrawerItem(
                icon: Icons.auto_awesome_outlined,
                label: 'Recomendar Atividades',
                onTap: () {
                  Navigator.of(context).pop();
                  ActivitiesListPageRouter.go(context);
                },
              ),
              HomeDrawerItem(
                icon: Icons.insert_chart_outlined,
                label: 'Gerar Relatorios',
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tela em desenvolvimento.')),
                  );
                },
              ),
              const Spacer(),
              const Divider(height: 1),
              const SizedBox(height: 8),
              HomeDrawerItem(
                icon: Icons.logout_outlined,
                label: 'Sair',
                danger: true,
                onTap: () async {
                  Navigator.of(context).pop();
                  await _logout();
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  String _initialsFromName(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '??';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();

    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  String _formatDeltaLabel(int delta) {
    if (delta > 0) return '+$delta%';
    if (delta < 0) return '$delta%';
    return '0%';
  }
}
